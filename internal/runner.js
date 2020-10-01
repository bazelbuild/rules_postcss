/**
 * Copyright 2019 The Bazel Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Node.js binary that runs PostCSS with specified inputs and
 * plugins, generated via a template. TEMPLATE_* symbols are substituted when
 * this binary is generated.
 */

const fs = require('fs');
const minimist = require('minimist');
const path = require('path');
const postcss = require('postcss');
const runfiles = require(process.env['BAZEL_NODE_RUNFILES_HELPER']);
const worker = require('@bazel/worker');

/**
 * Returns the argument named `name` as an array.
 *
 * Minimist automatically converts args that are passed multiple times into
 * arrays. This ensures a consistent representation if the same arg is passed
 * zero or one times.
 */
function argAsArray(args, name) {
  const value = args[name];
  if (!value) return [];
  if (typeof value === 'string') return [value];
  return value;
}

function compile(rawArgs) {
  const args = minimist(rawArgs);
  const cwd = process.cwd();

  const data = argAsArray(args, 'data');
  for (const pair of argAsArray(args, 'namedData')) {
    const [name, value] = pair.split(':');
    (data[name] = data[name] || []).push(value);
  }
  
  // These variables are documented in `postcss_binary`'s docstring and are
  // fair game for plugin configuration to read.
  const bazel = {
    binDir: args.binDir,
    data: data,
    additionalOutputs: argAsArray(args, 'additionalOutputs'),
  };

  const cssString = fs.readFileSync(args.cssFile, 'utf8');

  const options = {
    // The path of the input CSS file.
    from: args.cssFile,
    // The path of the output CSS file.
    to: args.outCssFile,
    map: args.sourcemap
        ? {
            // Don't output source map inline, we want it as a separate file.
            inline: false,
            // Whether to add (or modify, if already existing) the
            // sourceMappingURL comment in the output .css to point to the
            // output .css.map.
            annotation: true,
          }
        : false,
  };

  // Get absolute output paths before we change directory.
  const outCssPath = path.join(cwd, args.outCssFile);
  const outCssMapPath =
      args.outCssMapFile ? path.join(cwd, args.outCssMapFile) : null;
  
  // We use two parallel arrays, PostCSS plugin requires => strings of JS args.
  // To use in PostCSS, convert these into the actual plugin instances.
  const pluginRequires = argAsArray(args, 'pluginRequires');
  const pluginArgs = argAsArray(args, 'pluginArgs');
  const pluginInstances = pluginRequires.map(
      (nodeRequire, i) => {
        // Try and resolve this plugin as a module identifier.
        let plugin;
        try {
          plugin = require(nodeRequire);
        } catch { }

        // If it fails, use the runfile helper in case it's a workspace file.
        if (!plugin) {
          try {
            plugin = require(runfiles.resolve(nodeRequire));
          } catch { }
        }

        // If that still fails, throw an error.
        if (!plugin) {
          const e = new Error(
              `could not resolve plugin with node require ${nodeRequire}`);
          e.code = 'MODULE_NOT_FOUND';
          throw e;
        }

        return plugin.apply(this, eval(pluginArgs[i]));
      });
  
  return postcss(pluginInstances)
      .process(cssString, options)
      .then(
          result => {
            fs.writeFileSync(outCssPath, result.css);
            if (args.sourcemap && result.map) {
              fs.writeFileSync(outCssMapPath, result.map);
            }
            return true;
          },
          e => {
            worker.log('Error in processing. Args:', args);
            worker.log('Error:', e);
            return false;
          });
}

if (worker.runAsWorker(process.argv)) {
  worker.log('PostCSS runner starting as worker...');
  worker.runWorkerLoop(compile);
} else {
  console.log('PostCSS runner starting standalone...');

  // If the first param starts with @, this is a Bazel param file. Otherwise,
  // treat the params as coming directly from argv.
  let args;
  if (process.argv[2].startsWith('@')) {
    const paramFile = process.argv[2].replace(/^@/, '');
    args = fs.readFileSync(paramFile, 'utf-8').trim().split('\n');
  } else {
    args = process.argv.slice(2);
  }

  compile(args).then(
      success => {
        // Arbitrary exit code for failure, otherwise we exit succesfully.
        if (!success) {
          process.exit(2);
        }
      });
}

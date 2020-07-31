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

const args = minimist(process.argv.slice(2));
const cwd = process.cwd();

/**
 * Returns the argument named `name` as an array.
 *
 * Minimist automatically converts args that are passed multiple times into
 * arrays. This ensures a consistent representation if the same arg is passed
 * zero or one times.
 */
function argAsArray(name) {
  const value = args[name];
  if (!value) return [];
  if (typeof value === 'string') return [value];
  return value;
}

const data = argAsArray('data');
for (const pair of argAsArray('namedData')) {
  const [name, value] = pair.split(':');
  (data[name] = data[name] || []).push(value);
}

// These variables are documented in `postcss_binary`'s docstring and are fair
// game for plugin configuration to read.
const bazel = {
  binDir: args.binDir,
  data: data,
  additionalOutputs: argAsArray('additionalOutputs'),
};

const cssString = fs.readFileSync(args.cssFile, 'utf8');

const options = {
  // The path of the input CSS file.
  from: args.cssFile,
  // The path of the output CSS file.
  to: args.outCssFile,
  map: TEMPLATED_sourcemap
      ? {
          // Don't output the source map inline, we want it as a separate file.
          inline: false,
          // Whether to add (or modify, if already existing) the
          // sourceMappingURL comment in the output .css to point to the output
          // .css.map.
          annotation: true,
        }
      : false,
};

// Get absolute output paths before we change directory.
const outCssPath = path.join(cwd, args.outCssFile);
const outCssMapPath =
    args.outCssMapFile ? path.join(cwd, args.outCssMapFile) : null;

// We receive a map of PostCSS plugin requires => array of args to the plugins.
// To use in PostCSS, convert this map into the actual plugin instances.
const pluginMap = TEMPLATED_plugins;
const pluginInstances = Object.entries(pluginMap).map(
    ([nodeRequire, args]) => {
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

      return plugin.apply(this, args);
    });

postcss(pluginInstances)
    .process(cssString, options)
    .then(
        result => {
          fs.writeFileSync(outCssPath, result.css);
          if (TEMPLATED_sourcemap && result.map) {
            fs.writeFileSync(outCssMapPath, result.map);
          }
        },
        e => {
          console.warn('Error in processing. Args:', args);
          console.warn('Error:', e);
          process.exit(2);
        });

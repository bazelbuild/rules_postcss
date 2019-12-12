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

const args = minimist(process.argv.slice(2));
const binDir = args.binDir;
const cssString = fs.readFileSync(args.cssFile, 'utf8');
const cssMapString =
    args.cssMapFile ? fs.readFileSync(args.cssMapFile, 'utf8') : null;

const options = {
  // The path of the input CSS file.
  from: args.cssFile,
  // The path of the output CSS file.
  to: args.outCssFile,
  map: {
    // Don't output the source map inline, we want it as a separate file.
    inline: false,
    // The input source map, if it was provided.
    prev: cssMapString || undefined,
    // Whether to add (or modify, if already existing) the sourceMappingURL
    // comment in the output .css to point to the output .css.map.
    annotation: TEMPLATED_map_annotation,
  }
};

// Change to the bin directory so that plugins that emit files can do so
// relative to the output root of the workspace.
//const cwd = process.cwd();
//const newDir = path.join(cwd, binDir);
//process.chdir(newDir);

postcss(TEMPLATED_plugins)
    .process(cssString, options)
    .then(
        result => {
          // Change back to the original cwd, because the .css and .css.map
          // output paths were supplied relative to it.
          //process.chdir(cwd);

          fs.writeFileSync(args.outCssFile, result.css);
          if (result.map) {
            fs.writeFileSync(args.outCssMapFile, result.map);
          }
        },
        e => {
          console.warn('Error in processing. Args:', args);
          console.warn('Error:', e);
          process.exit(2);
        });

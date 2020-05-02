/**
 * Copyright 2020 The Bazel Authors
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
 * @fileoverview Example PostCSS plugin that injects a text file as a header
 * comment.
 */

const fs = require('fs');
const postcss = require('postcss');

module.exports = postcss.plugin('header', (opts = {}) => {
  const contents = fs.readFileSync(opts.path, 'utf8').trim();

  return css => {
    css.prepend(postcss.comment({text: contents}));
  };
});

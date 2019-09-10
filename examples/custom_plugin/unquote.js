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
 * @fileoverview Example PostCSS plugin that introduces an "unquote" function
 * to stylesheets.
 */

const postcss = require('postcss');

// Replaces all "unquote('hello')" found with "hello", supporting
// both ' and ". Doesn't do quote escaping.
module.exports = postcss.plugin('unquote', (opts = {}) => {
  /**
   * Unquote implementation. http://stackoverflow.com/a/19584742
   * @param {string} str
   * @return {string} The string with unquote instances handled.
   */
  const unquoteStr = str => {
    if (str.indexOf('unquote(') !== -1) {
      return str.replace(/unquote\((["'])(.+?)\1\)/g, '$2');
    }
    return str;
  };

  return css => {
    // Handle declaration values in rules.
    css.walkRules(rule => {
      rule.walkDecls((decl, i) => decl.value = unquoteStr(decl.value));
    });
    // Handle params in @rules.
    css.walkAtRules(rule => rule.params = unquoteStr(rule.params));
  };
});

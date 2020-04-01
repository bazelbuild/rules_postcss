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
 * @fileoverview Example PostCSS plugin that outputs a file listing all unique
 * CSS selectors found.
 */

const fs = require('fs');
const path = require('path');
const postcss = require('postcss');

// Outputs a file listing all unique CSS selectors found.
module.exports = postcss.plugin('list-selectors', (opts = {}) => {
  return css => {
    let totalSelectors = 0;
    const selectorCounts = {};
    css.walkRules(rule => {
      for (const selector of rule.selectors) {
        if (!(selector in selectorCounts)) {
          selectorCounts[selector] = 0;
        }
        selectorCounts[selector]++;
        totalSelectors++;
      }
    });

    let markdown = `# Found ${Object.keys(selectorCounts).length} unique selectors`
        + ` (of ${totalSelectors} total)\n`;
    for (let selector in selectorCounts) {
      markdown += `\n- ${selector} (${selectorCounts[selector]} total)`
    }

    fs.writeFileSync(opts.output, markdown);
  };
});

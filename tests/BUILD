# Copyright 2019 The Bazel Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@bazel_tools//tools/build_rules:test_rules.bzl", "file_test", "rule_test")

package(default_visibility = ["//visibility:private"])

AUTOPREFIXER_OUTPUT = """body {
  font: 42px 'Comic Sans MS';
  -webkit-box-flex: 42;
  -webkit-flex: 42 -42 auto;
      -ms-flex: 42 -42 auto;
          flex: 42 -42 auto;
}
"""

file_test(
    name = "autoprefixer_test",
    content = AUTOPREFIXER_OUTPUT,
    file = "//examples/autoprefixer:style_processed.css",
)

RTLCSS_OUTPUT = """body {
  direction: rtl;
  margin: 5px 25px 20px 10px;
  padding: 4px 16px 12px 8px;
  border-width: 1px 4px 3px 2px;
}
"""

file_test(
    name = "rtlcss_test",
    content = RTLCSS_OUTPUT,
    file = "//examples/rtlcss:style_processed.css",
)

CUSTOM_PLUGIN_OUTPUT = """@media screen and (max-width: $(sidebar.width)) {
  body {
    font: $(blog.title.font.size) 'Comic Sans MS';
    flex: 42 -42 auto;
  }
}
"""

file_test(
    name = "custom_plugin_test",
    content = CUSTOM_PLUGIN_OUTPUT,
    file = "//examples/custom_plugin:style_processed.css",
)

file_test(
    name = "custom_plugin_ts_test",
    content = CUSTOM_PLUGIN_OUTPUT,
    file = "//examples/custom_plugin_ts:style_processed.css",
)

DATA_ATTR_OUTPUT = """/* This goes at the beginning of the file. */
@media screen and (max-width: 10px) {
  body {
    font: 42px 'Comic Sans MS';
    flex: 42 -42 auto;
  }
}
"""

file_test(
    name = "data_attr_test",
    content = DATA_ATTR_OUTPUT,
    file = "//examples/data_attr:style_processed.css",
)

file_test(
    name = "positional_data_attr_test",
    content = DATA_ATTR_OUTPUT,
    file = "//examples/positional_data_attr:style_processed.css",
)

ADDITIONAL_OUTPUT = """# Found 4 unique selectors (of 6 total)

- body (1 total)
- .container (2 total)
- .image.full-width (2 total)
- .image (1 total)"""

file_test(
    name = "additional_outputs_test",
    content = ADDITIONAL_OUTPUT,
    file = "//examples/additional_outputs:selectors.md",
)

file_test(
    name = "sourcemap_css_test",
    file = "//examples/sourcemap:style_processed.css",
    regexp = "/\\*# sourceMappingURL=style_processed\\.css\\.map \\*/",
)

# Test that not only is a source map generated, it points to the original Sass
# file.
file_test(
    name = "sourcemap_map_test",
    file = "//examples/sourcemap:style_processed.css.map",
    regexp = "style\\.scss",
)

rule_test(
    name = "multi_binary_test",
    generates = [
        "styles/examples/multi_binary/style1.css",
        "styles/examples/multi_binary/style2.css",
    ],
    rule = "//examples/multi_binary:styles",
)

rule_test(
    name = "multi_sourcemap_test",
    generates = [
        "styles/examples/multi_sourcemap/style1.css",
        "styles/examples/multi_sourcemap/style1.css.map",
        "styles/examples/multi_sourcemap/style2.css",
        "styles/examples/multi_sourcemap/style2.css.map",
    ],
    rule = "//examples/multi_sourcemap:styles",
)

WRAPPER_OUTPUT = """body {
    padding: 42px 36px 38px 40px;
}
/*hello!*/
"""

file_test(
    name = "wrapper_test",
    content = WRAPPER_OUTPUT,
    file = "//examples/wrapper:style_processed.css",
)

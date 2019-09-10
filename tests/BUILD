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

load("@bazel_tools//tools/build_rules:test_rules.bzl", "file_test")

package(default_visibility = ["//visibility:private"])

file_test(
    name = "autoprefixer_test",
    content = """body {
  font: 42px 'Comic Sans MS';
  -webkit-box-flex: 42;
  -webkit-flex: 42 -42 auto;
      -ms-flex: 42 -42 auto;
          flex: 42 -42 auto;
}
""",
    file = "//examples/autoprefixer:style_processed.css",
)

file_test(
    name = "custom_plugin_test",
    content = """@media screen and (max-width: 42px) {
  body {
    font: 42px "Comic Sans MS";
    -webkit-box-flex: 42;
    -webkit-flex: 42 -42 auto;
        -ms-flex: 42 -42 auto;
            flex: 42 -42 auto;
  }
}

/*# sourceMappingURL=style.css.map */
""",
    file = "//examples/custom_plugin:style_processed.css",
)

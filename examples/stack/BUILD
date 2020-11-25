# Copyright 2020 The Bazel Authors
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

load("//:index.bzl", "postcss_binary", "postcss_plugin", "postcss_stack")

package(default_visibility = ["//tests:__subpackages__"])

AUTO_PREFIXER_BROWSERS = "ie >= 9, edge >= 12, firefox >= 42, chrome >= 32, safari >= 8, opera >= 38, ios_saf >= 9.2, android >= 4.3, and_uc >= 9.9"

postcss_plugin(
    name = "autoprefixer",
    node_require = "autoprefixer",
    visibility = ["//visibility:public"],
    deps = [
        "@npm//autoprefixer",
    ],
)

postcss_stack(
    name = "stack",
    plugins = {
        "//examples/stack:autoprefixer": "[{ browsers: '%s' }]" % AUTO_PREFIXER_BROWSERS,
        "//examples/custom_plugin:unquote": "",
    },
)

postcss_binary(
    name = "style1_processed",
    src = "style1.css",
    stack = ":stack",
)

postcss_binary(
    name = "style2_processed",
    src = "style2.css",
    stack = ":stack",
)

postcss_binary(
    name = "style3_processed",
    src = "style3.css",
    stack = ":stack",
)

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

load("//:defs.bzl", "postcss_plugin", "postcss_multi_binary")

package(default_visibility = ["//tests:__subpackages__"])

AUTO_PREFIXER_BROWSERS = "ie >= 9, edge >= 12, firefox >= 42, chrome >= 32, safari >= 8, opera >= 38, ios_saf >= 9.2, android >= 4.3, and_uc >= 9.9"

postcss_plugin(
    name = "autoprefixer",
    node_require = "autoprefixer",
    deps = ["@npm//autoprefixer"],
)

postcss_multi_binary(
    name = "styles",
    srcs = ["style1.css", "style2.css"],
    output_pattern = "{rule}/{dir}/{name}",
    plugins = {
        ":autoprefixer": "[{ browsers: '%s' }]" % AUTO_PREFIXER_BROWSERS,
    },
)

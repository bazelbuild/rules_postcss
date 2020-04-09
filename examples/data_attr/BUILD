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

load("@io_bazel_rules_sass//:defs.bzl", "sass_binary")
load("//:defs.bzl", "postcss_binary", "postcss_plugin")

package(default_visibility = ["//tests:__subpackages__"])

postcss_plugin(
    name = "header",
    node_require = "build_bazel_rules_postcss/examples/data_attr/header.js",
    srcs = ["header.js"],
)

sass_binary(
    name = "style",
    src = "style.scss",
    output_style = "expanded",
)

postcss_binary(
    name = "style_processed",
    src = ":style",
    data = ["header.txt"],
    plugins = {
        ":header": "[{ path: bazel.data[0] }]",
    },
)

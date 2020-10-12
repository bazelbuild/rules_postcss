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

load("@build_bazel_rules_postcss//:index.bzl", "postcss_binary", "postcss_plugin")

package(default_visibility = ["//visibility:public"])

postcss_plugin(
    name = "list_selectors",
    srcs = [
        "list-selectors.js",
    ],
    node_require = "build_bazel_rules_postcss_examples/additional_outputs/list-selectors.js",
)

postcss_binary(
    name = "style_processed",
    src = "style.css",
    additional_outputs = ["selectors.md"],
    plugins = {
        ":list_selectors": "[{ output: bazel.additionalOutputs[0] }]",
    },
)

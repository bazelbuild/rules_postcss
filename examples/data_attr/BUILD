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

load("//:index.bzl", "postcss_binary", "postcss_plugin")

package(default_visibility = ["//tests:__subpackages__"])

postcss_plugin(
    name = "header",
    srcs = ["header.js"],
    node_require = "build_bazel_rules_postcss/examples/data_attr/header.js",
)

postcss_binary(
    name = "style_processed",
    src = "style.css",
    named_data = {"header": "header.txt"},
    plugins = {
        ":header": "[{ path: bazel.data.header[0] }]",
    },
)

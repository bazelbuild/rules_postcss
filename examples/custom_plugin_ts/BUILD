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
load("@npm_bazel_typescript//:index.bzl", "ts_library")
load("//:defs.bzl", "postcss_binary", "postcss_plugin")

package(default_visibility = ["//tests:__subpackages__"])

AUTO_PREFIXER_BROWSERS = "ie >= 9, edge >= 12, firefox >= 42, chrome >= 32, safari >= 8, opera >= 38, ios_saf >= 9.2, android >= 4.3, and_uc >= 9.9"

postcss_plugin(
    name = "autoprefixer",
    node_require = "autoprefixer",
)

ts_library(
    name = "unquote_ts",
    srcs = ["unquote.ts"],
    deps = [
      "@npm//@types",
      "@npm//postcss",
    ],
)

filegroup(
    name = "unquote_js",
    srcs = [":unquote_ts"],
    output_group = "es5_sources",
)

postcss_plugin(
    name = "unquote",
    node_require = "build_bazel_rules_postcss/examples/custom_plugin_ts/unquote.js",
    srcs = [
        ":unquote_js",
    ],
)

sass_binary(
    name = "style",
    src = "style.scss",
    output_style = "expanded",
)

postcss_binary(
    name = "style_processed",
    src = ":style",
    plugins = {
        ":autoprefixer": "[{ browsers: '%s' }]" % AUTO_PREFIXER_BROWSERS,
        ":unquote": "",
    },
    deps = [
        ":unquote",
        "@npm//autoprefixer",
    ],
)

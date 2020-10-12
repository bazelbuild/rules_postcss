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

load("@bazel_skylib//:bzl_library.bzl", "bzl_library")
# BEGIN-INTERNAL
load("@build_bazel_rules_nodejs//:index.bzl", "pkg_npm")
# END-INTERNAL

bzl_library(
    name = "build_defs",
    srcs = ["index.bzl"],
    deps = [
        "//internal:build_defs",
        "//internal/autoprefixer:build_defs",
        "//internal/rtlcss:build_defs",
    ],
)

exports_files(["LICENSE"])

# BEGIN-INTERNAL
pkg_npm(
    name = "npm_package",
    srcs = [
        "BUILD",
        "index.bzl",
        "LICENSE",
        "package.bzl",
        "package.json",
        "README.md",
    ],
    deps = [
        "//internal:package_contents",
        "//internal/autoprefixer:package_contents",
        "//internal/rtlcss:package_contents",
    ],
    substitutions = {
        "@build_bazel_rules_postcss//": "@npm//@bazel/postcss/",
    },
)
# END-INTERNAL

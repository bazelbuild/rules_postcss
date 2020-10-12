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

filegroup(
    name = "package_contents",
    srcs = glob(["*"]),
    visibility = ["//:__pkg__"],
)

bzl_library(
    name = "build_defs",
    srcs = glob(["*.bzl"]),
    deps = [
        "@bazel_skylib//lib:dicts",
        "@bazel_skylib//lib:paths",
        "@build_bazel_rules_nodejs//:bzl",
    ],
    visibility = ["//:__subpackages__"],
)

exports_files(["runner.js"])

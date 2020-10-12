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

"""Fetches transitive dependencies required for the PostCSS rule examples"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Buildifier thinks this is a build target macro because of using native.*.
# buildifier: disable=unnamed-macro
def rules_postcss_examples_dependencies():
    # NodeJS rules.
    http_archive(
        name = "build_bazel_rules_nodejs",
        sha256 = "5bf77cc2d13ddf9124f4c1453dd96063774d755d4fc75d922471540d1c9a8ea8",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/2.0.0/rules_nodejs-2.0.0.tar.gz"],
    )

    # Sass rules.
    http_archive(
        name = "io_bazel_rules_sass",
        sha256 = "9dcfba04e4af896626f4760d866f895ea4291bc30bf7287887cefcf4707b6a62",
        urls = [
            "https://github.com/bazelbuild/rules_sass/archive/1.26.3.zip",
            "https://mirror.bazel.build/github.com/bazelbuild/rules_sass/archive/1.26.3.zip",
        ],
        strip_prefix = "rules_sass-1.26.3",
    )

    # PostCSS rules.
    native.local_repository(
        name = "build_bazel_rules_postcss",
        path = "../",
    )

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

"""Fetches transitive dependencies required for using the PostCSS rules"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _include_if_not_defined(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def rules_postcss_dependencies():
    # NodeJS rules.
    _include_if_not_defined(
        http_archive,
        name = "build_bazel_rules_nodejs",
        sha256 = "e1a0d6eb40ec89f61a13a028e7113aa3630247253bcb1406281b627e44395145",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/1.0.1/rules_nodejs-1.0.1.tar.gz"],
    )

    # Sass rules.
    _include_if_not_defined(
        http_archive,
        name = "io_bazel_rules_sass",
        sha256 = "617e444f47a1f3e25eb1b6f8e88a2451d54a2afdc7c50518861d9f706fc8baaa",
        urls = [
            "https://github.com/bazelbuild/rules_sass/archive/1.23.7.zip",
            "https://mirror.bazel.build/github.com/bazelbuild/rules_sass/archive/1.23.7.zip",
        ],
        strip_prefix = "rules_sass-1.23.7",
    )

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

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _include_if_not_defined(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)

def rules_postcss_dependencies():
    # Skylib.
    _include_if_not_defined(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    )

    _include_if_not_defined(
        git_repository,
        name = "io_bazel_stardoc",
        remote = "https://github.com/bazelbuild/stardoc.git",
        commit = "247c2097e7346778ac8d03de5a4770d6b9890dc5",
    )

    # NodeJS rules.
    _include_if_not_defined(
        http_archive,
        name = "build_bazel_rules_nodejs",
        # Un-dummy-ify skylib loading so that we can dep on bzl_library targets
        # from rules_nodejs (i.e. those for nodejs_binary). Having correct deps
        # in bzl_library is required for skydoc to function.
        patches = ["@build_bazel_rules_postcss//:rules_nodejs_skylib.patch"],
        sha256 = "5bf77cc2d13ddf9124f4c1453dd96063774d755d4fc75d922471540d1c9a8ea8",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/2.0.0/rules_nodejs-2.0.0.tar.gz"],
    )

    # Sass rules.
    _include_if_not_defined(
        http_archive,
        name = "io_bazel_rules_sass",
        sha256 = "9dcfba04e4af896626f4760d866f895ea4291bc30bf7287887cefcf4707b6a62",
        urls = [
            "https://github.com/bazelbuild/rules_sass/archive/1.26.3.zip",
            "https://mirror.bazel.build/github.com/bazelbuild/rules_sass/archive/1.26.3.zip",
        ],
        strip_prefix = "rules_sass-1.26.3",
    )

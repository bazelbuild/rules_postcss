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
    # Skylib.
    _include_if_not_defined(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.0/bazel-skylib-1.2.0.tar.gz",
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.2.0/bazel-skylib-1.2.0.tar.gz",
        ],
        sha256 = "af87959afe497dc8dfd4c6cb66e1279cb98ccc84284619ebfec27d9c09a903de",
    )

    _include_if_not_defined(
        http_archive,
        name = "io_bazel_stardoc",
        urls = ["https://github.com/bazelbuild/stardoc/archive/cdd19379490c681563b38ef86299f039bd368ce0.tar.gz"],
        strip_prefix = "stardoc-cdd19379490c681563b38ef86299f039bd368ce0",
        sha256 = "e9b7ef1439ead6bfaaf419bab643fcd5566ef2306c011f4ccf549e2a4c779d01",
    )

    # NodeJS rules.
    _include_if_not_defined(
        http_archive,
        name = "build_bazel_rules_nodejs",
        sha256 = "965ee2492a2b087cf9e0f2ca472aeaf1be2eb650e0cfbddf514b9a7d3ea4b02a",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.2.0/rules_nodejs-5.2.0.tar.gz"],
    )

    # Sass rules.
    _include_if_not_defined(
        http_archive,
        name = "io_bazel_rules_sass",
        sha256 = "6e463c0cdfb8d2dc807c9f4c67fab8911e19b6ea6e2900df1363258b4d1cbfa0",
        urls = [
            "https://github.com/bazelbuild/rules_sass/archive/1.49.8.tar.gz",
        ],
        strip_prefix = "rules_sass-1.49.8",
    )

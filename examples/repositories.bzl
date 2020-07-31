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

"""Install PostCSS example dependencies"""

load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")
load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
load("@build_bazel_rules_postcss//:repositories.bzl", "postcss_repositories")

def postcss_examples_repositories():
    """Set up environment for PostCSS examples."""

    yarn_install(
        name = "npm",
        package_json = "@build_bazel_rules_postcss_examples//:package.json",
        yarn_lock = "@build_bazel_rules_postcss_examples//:yarn.lock",
    )

    rules_sass_dependencies()
    sass_repositories()

    postcss_repositories()
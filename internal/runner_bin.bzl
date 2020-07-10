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

"""PostCSS runner binary rule.

Sets up common deps and entry point for the PostCSS runner."""

load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")

def postcss_runner_bin(
        name,
        deps,
        **kwargs):
    """Sets up a nodejs_binary for the PostCSS runner with common deps.

    Args:
        name: The name of the build rule.
        deps: Additional NodeJS modules the runner will depend on. The PostCSS
            module is always implicitly included.
        **kwargs: Additional arguments to pass to nodejs_binary().
    """

    nodejs_binary(
        name = name,
        entry_point = "@build_bazel_rules_postcss//internal:runner.js",
        data = [
            "@npm//minimist",
            "@npm//postcss",
            "@npm//@bazel/worker",
        ] + deps,
        **kwargs
    )

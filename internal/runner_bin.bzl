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

Creates a nodejs_binary given our generated internal runner source. This file
can be substituted in your copies of these build rules, for example due to
differences in Node.js/Starlark build rules."""

load("@build_bazel_rules_nodejs//:defs.bzl", "nodejs_binary")

def postcss_runner_bin(
        name,
        src,
        deps,
        visibility = None):
    """Convenience helper for using nodejs_binary with the PostCSS runner.

    Args:
        name: The name of the build rule.
        src: The source file and entry point of the nodejs_binary.
        deps: What the nodejs_binary depends on.
        visibility: The visibility of the build rule.
    """

    nodejs_binary(
        name = name,
        entry_point = ":%s" % (src),
        data = deps,
        visibility = visibility,
    )

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

"""PostCSS binary rule.

Building a postcss_binary target builds an internal PostCSS runner, and runs
it using a provided list of PostCSS plugins, against input .css (and optionally
.css.map).
"""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load(":gen_runner.bzl", "postcss_gen_runner")
load(":run.bzl", "postcss_run")

def postcss_binary(
        name,
        plugins,
        src,
        deps = [],
        additional_outputs = [],
        output_name = "",
        map_annotation = False,
        **kwargs):
    """Runs PostCSS.

    Args:
        name: The name of the build rule.
        plugins: A map of plugin Node.js require paths (following the
            requirements of rules_nodejs), with values being config objects
            for each respective plugin.
        src: The input .css, and optionally .css.map files. (This includes
            outputs from preprocessors such as sass_binary.)
        deps: A list of NodeJS modules the config depends on. The PostCSS module
            is always implicitly included.
        additional_outputs: Any additional outputs that are generated by the
            provided plugins.
        output_name: Output name.
        map_annotation: Whether to add (or modify, if already existing) the
            sourceMappingURL comment in the output .css to point to the output
            .css.map.
        **kwargs: Standard BUILD arguments to pass.
    """

    runner_name = "%s.postcss_runner" % name

    postcss_gen_runner(
        name = runner_name,
        plugins = plugins,
        deps = deps + plugins.keys(),
        map_annotation = map_annotation,
        **dicts.add(kwargs, {"visibility": ["//visibility:private"]})
    )

    postcss_run(
        name = name,
        src = src,
        output_name = output_name,
        additional_outputs = additional_outputs,
        runner = runner_name,
        **kwargs
    )

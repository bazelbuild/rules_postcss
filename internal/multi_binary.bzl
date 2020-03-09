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

"""A rule that compiles multiple CSS files with the same PostCSS configuration.

This works like `postcss_binary` except that it takes multiple CSS sources and
declares a separate action for each of them.
"""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load(":gen_runner.bzl", "postcss_gen_runner")
load(":run.bzl", "postcss_multi_run")

def postcss_multi_binary(
        name,
        plugins,
        deps,
        srcs,
        output_pattern,
        map_annotation = False,
        **kwargs):
    """Compiles multiple CSS files with the same PostCSS configuration.

    This should generally be avoided if postcss_binary would suffice. It's
    intended to be used when the set of files to compile aren't known during the
    loading phase.

    Args:
        name: The name of the build rule.
        plugins: A map of plugin Node.js require paths (following the
            requirements of rules_nodejs), with values being config objects
            for each respective plugin.
        deps: A list of NodeJS modules the config depends on. The PostCSS module
            is always implicitly included.
        srcs: The input .css (and optionally .css.map) files. If a .css.map file
            is passed, its corresponding .css file must also exist.
        output_pattern: A named pattern for the output file generated for each
            input CSS file.

            This pattern can include any or all of the following variables:

            * "{name}", the input CSS file's basename.
            * "{dir}", the input CSS file's directory name relative to the root
              of the workspace.
            * "{rule}", the name of this rule.

            It defaults to "{rule}/{name}".
        map_annotation: Whether to add (or modify, if already existing) the
            sourceMappingURL comment in the output .css to point to the output
            .css.map.
        **kwargs: Standard BUILD arguments to pass.

    """

    runner_name = "%s.postcss_runner" % name

    plugins_keyed_by_infos = {}
    for key, value in plugins.items():
        plugins_keyed_by_infos["%s.info" % key] = value

    postcss_gen_runner(
        name = runner_name,
        plugins = plugins_keyed_by_infos,
        deps = deps,
        map_annotation = map_annotation,
        **dicts.add(kwargs, {"visibility": ["//visibility:private"]})
    )

    postcss_multi_run(
        name = name,
        srcs = srcs,
        output_pattern = output_pattern,
        runner = runner_name,
        **kwargs
    )

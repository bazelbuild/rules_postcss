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
load(":runner_bin.bzl", "postcss_runner_bin")
load(":run.bzl", "postcss_run")

def postcss_binary(
        name,
        plugins,
        src,
        deps = [],
        additional_outputs = [],
        output_name = "",
        sourcemap = False,
        data = [],
        named_data = {},
        wrapper = None,
        **kwargs):
    """Runs PostCSS.

    Args:
        name: The name of the build rule.
        plugins: A map of postcss_plugin targets to JavaScript config object
            strings.

            Plugin configurations are interpreted as JavaScript code, and can
            refer to the following pre-defined variables:

            * `bazel.binDir`: The root of Bazel's generated binary tree.

            * `bazel.additionalOutputs`: An array of all the file paths passed
              to the `additional_outputs` attribute of `postcss_binary`, to
              which a plugin is expected to write.

            * `bazel.data`: An array of all the file paths for targets passed to
              the `data` or `named_data` attribute of `postcss_binary`.

              `bazel.data.${name}` can also be used to access the file paths for
              individual targets passed to `named_data`. For example, if you
              pass `named_data = {"license": "license.txt"}`, you can access
              the path of the license file via `bazel.data.license[0]`.

              It's strongly recommended to use `named_data` over `data` when you
              want to access a specific target's file(s), and only use the array
              value to access *all* data files no matter which target they come
              from.

        src: The input .css, and optionally .css.map files. (This includes
            outputs from preprocessors such as sass_binary.)
        deps: Additional NodeJS modules the config depends on. The PostCSS
            module and plugin modules are always implicitly included.
        additional_outputs: Any additional outputs that are generated by the
            provided plugins.
        output_name: Output name.
        sourcemap: Whether to generate a source map. If False, any existing
            sourceMappingURL comment is deleted.
        data: Standard Bazel argument.
        named_data: A map from names to targets to use as data dependencies.
            This works just like `data` except that the targets' files can be
            accessed through `bazel.data.${name}`.
        wrapper: Wrapper for the postcss binary. If passed, the wrapper is run
            in place of the postcss binary, with an extra first arg pointing
            to the actual postcss binary.
        **kwargs: Standard BUILD arguments to pass.
    """

    runner_name = "%s.postcss_runner" % name

    postcss_runner_bin(
        name = runner_name,
        src = "@build_bazel_rules_postcss//internal:runner-template.js",
        deps = [
            "@npm//minimist",
            "@npm//postcss",
        ] + plugins.keys(),
        **dicts.add(kwargs, {"visibility": ["//visibility:private"]})
    )

    postcss_run(
        name = name,
        src = src,
        output_name = output_name,
        additional_outputs = additional_outputs,
        plugins = plugins,
        runner = runner_name,
        sourcemap = sourcemap,
        data = data,
        named_data = named_data,
        wrapper = wrapper,
        **kwargs
    )

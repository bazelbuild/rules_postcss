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

"""PostCSS stack rule.

Using postcss_stack allows reuse of PostCSS plugin configuration. (Without
resorting to methods such as top-level constants.)

When postcss_stack is used in conjunction with workers for postcss_binary,
the worker process will be able to cache instantiated PostCSS plugins.
"""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load(":runner_bin.bzl", "postcss_runner_bin")

PostcssPluginsInfo = provider("""Provides a list of plugins.""", fields = ["plugins"])

def _postcss_plugins_info_impl(ctx):
    return [
        PostcssPluginsInfo(plugins = ctx.attr.plugins),
    ]

postcss_plugins_info = rule(
    implementation = _postcss_plugins_info_impl,
    attrs = {
        "plugins": attr.label_keyed_string_dict(
            cfg = "exec",
            mandatory = True,
        ),
        "deps": attr.label_list(),
    },
    doc = """Metadata about a PostCSS stack.

This rule provides extra metadata about this PostCSS plugin required when using
postcss_binary.""",
)

def postcss_stack(
        name,
        plugins = {},
        deps = [],
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

        deps: Additional NodeJS modules the config depends on. The PostCSS
            module and plugin modules are always implicitly included.
        **kwargs: Standard BUILD arguments to pass.
    """

    # If plugins are provided, create the provider target to be consumed by
    # postcss_run.
    stack_plugins_name = "%s.postcss_plugins" % name
    if plugins != None:
        postcss_plugins_info(
            name = stack_plugins_name,
            plugins = plugins,
        )

    postcss_runner_bin(
        name = name,
        deps = deps + plugins.keys(),
        **dicts.add(kwargs, {"visibility": ["//visibility:private"]})
    )

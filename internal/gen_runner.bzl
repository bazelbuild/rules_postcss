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

"""PostCSS runner rule.

This generates the internal PostCSS runner as a nodejs_binary, that can later
be used as an executable."""

load("@bazel_skylib//lib:dicts.bzl", "dicts")
load(":runner_bin.bzl", "postcss_runner_bin")
load(":plugin.bzl", "PostcssPluginInfo")

ERROR_INPUT_NO_PLUGINS = "No plugins were provided"

def _postcss_runner_src_impl(ctx):
    if len(ctx.attr.plugins.items()) == 0:
        fail(ERROR_INPUT_NO_PLUGINS)

    plugins = []
    for plugin_key, plugin_options in ctx.attr.plugins.items():
        node_require = plugin_key[PostcssPluginInfo].node_require
        plugins.append("require('%s').apply(this, %s)" %
                       (node_require, plugin_options if plugin_options else "[]"))

    ctx.actions.expand_template(
        template = ctx.file.template,
        output = ctx.outputs.postcss_runner_src,
        substitutions = {
            # The array of PostCSS plugin objects.
            "TEMPLATED_plugins": "[%s]" % (",".join(plugins)) if plugins else "",
            # Lowercase Python boolean converts to true/false.
            "TEMPLATED_sourcemap": str(ctx.attr.sourcemap).lower(),
        },
    )

postcss_runner_src = rule(
    implementation = _postcss_runner_src_impl,
    attrs = {
        "plugins": attr.label_keyed_string_dict(
            mandatory = True,
        ),
        "sourcemap": attr.bool(
            default = False,
        ),
        "template": attr.label(
            allow_single_file = [".js"],
            mandatory = True,
        ),
    },
    outputs = {
        "postcss_runner_src": "%{name}.js",
    },
)

def postcss_gen_runner(
        name,
        plugins,
        deps,
        sourcemap,
        **kwargs):
    """Generates a PostCSS runner binary.

    Pass the result to a postcss_run rule to apply the runner to a css file.

    Args:
        name: The name of the build rule.
        plugins: A map of plugin Node.js require paths (following the
            requirements of rules_nodejs), with values being config objects
            for each respective plugin.
        deps: A list of NodeJS modules the config depends on. The postcss module
            is included by default.
        sourcemap: Whether to generate source maps. If False, any existing
            sourceMappingURL comments are deleted.
        **kwargs: Standard BUILD arguments to pass.
    """

    runner_src_name = "%s.runner_src" % name

    postcss_runner_src(
        name = runner_src_name,
        plugins = plugins,
        sourcemap = sourcemap,
        template = "@build_bazel_rules_postcss//internal:runner-template.js",
        **dicts.add(kwargs, {"visibility": ["//visibility:private"]})
    )

    postcss_runner_bin(
        name = name,
        src = runner_src_name,
        deps = [
            "@npm//minimist",
            "@npm//postcss",
        ] + deps,
        **kwargs
    )

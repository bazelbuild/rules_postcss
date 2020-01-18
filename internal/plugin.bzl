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

"""PostCSS plugin rule.

Bundling PostCSS plugins as postcss_plugin targets defines their grouping of
Node.js source files, as well as promoting reuse of plugins across multiple
postcss_binary targets.
"""

PostcssPluginInfo = provider(fields=["node_require"])

def _postcss_plugin_info_impl(ctx):
    return [PostcssPluginInfo(node_require=ctx.attr.node_require)]

postcss_plugin_info = rule(
    implementation = _postcss_plugin_info_impl,
    attrs = {
        "node_require": attr.string(
            default = "",
            doc = """The Node.js require path for this plugin, following the
format expected by the Node.js build rules.""",
            mandatory = True,
        ),
    },
    doc = """Metadata about a PostCSS plugin.

This rule provides extra metadata about this PostCSS plugin required when using
postcss_binary."""
)

def postcss_plugin(
        name,
        node_require,
        srcs = [],
        data = [],
        deps = [],
        visibility = None):
    """Represents a Node.js module that is a PostCSS plugin.

    This provides extra metadata about PostCSS plugins that will be consumed by
    postcss_binary.

    For plugins that are from npm, adding the module as a dep is sufficient.
    For plugins that are from local sources, the sources must be added to srcs.

    Args:
        name: The name of the build rule.
        node_require: The require for the Node.js module.
        srcs: JS sources for the Node.js module, if any.
        data: Non-JS data files needed for the Node.js module.
        deps: Node.js module dependencies.
        visibility: The visibility of the build rule.
    """

    native.filegroup(
        name = name,
        srcs = srcs + data + deps,
        visibility = visibility,
    )

    postcss_plugin_info(
        name = "%s.info" % name,
        node_require = node_require,
        visibility = visibility,
    )

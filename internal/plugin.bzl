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

def postcss_plugin(
        name,
        srcs,
        data = [],
        deps = [],
        visibility = None):
    """Represents a Node.js module that is a PostCSS plugin.

    It is strongly recommended to use postcss_plugin to define PostCSS plugins
    as available targets, in lieu of nodejs_module.

    For forward compatibility purposes, although postcss_plugin is currently
    equivalent to defining a filegroup with arbitrary grouping, PostCSS plugins
    should be defined using postcss_plugin. This file can be substituted in
    internal copies of these build rules, which can make use of the extra
    grouping information.

    In the future, postcss_plugin targets are intended to provide extra
    information to postcss_binary rules. As such, using unsupported build rules
    to represent PostCSS plugins may lead to breakages in the future.

    Args:
        name: The name of the build rule.
        srcs: JS sources for the Node.js module.
        data: Non-JS data files needed for the Node.js module.
        deps: Other Node.js module/plugin dependencies.
        visibility: The visibility of the build rule.
    """

    native.filegroup(
        name = name,
        srcs = srcs + data + deps,
        visibility = visibility,
    )

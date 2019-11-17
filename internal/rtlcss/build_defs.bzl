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

"""Build rule for using rtlcss to postprocess CSS."""

load("//internal:binary.bzl", "postcss_binary")

def rtlcss(
        name,
        src,
        out,
        visibility = None):
    """Runs rtlcss on the given source files located in the given fileset.

    Args:
        name: A unique label for this rule.
        src: Source file or target.
        out: Output file.
        visibility: The visibility of the build rule.
    """

    postcss_binary(
        name = name,
        plugins = {
            "rtlcss": "",
        },
        deps = [
            "@npm//rtlcss",
        ],
        src = src,
        output_name = out,
        visibility = visibility,
    )

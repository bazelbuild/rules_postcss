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

"""Public API surface is re-exported here.

Users should not load files under "/internal"
"""

load("@build_bazel_rules_postcss//internal:plugin.bzl", _postcss_plugin = "postcss_plugin")
load("@build_bazel_rules_postcss//internal:binary.bzl", _postcss_binary = "postcss_binary")
load("@build_bazel_rules_postcss//internal:multi_binary.bzl", _postcss_multi_binary = "postcss_multi_binary")
load("@build_bazel_rules_postcss//internal:stack.bzl", _postcss_stack = "postcss_stack")
load("@build_bazel_rules_postcss//internal/autoprefixer:build_defs.bzl", _autoprefixer = "autoprefixer")
load("@build_bazel_rules_postcss//internal/rtlcss:build_defs.bzl", _rtlcss = "rtlcss")

postcss_plugin = _postcss_plugin
postcss_binary = _postcss_binary
postcss_multi_binary = _postcss_multi_binary
postcss_stack = _postcss_stack
autoprefixer = _autoprefixer
rtlcss = _rtlcss

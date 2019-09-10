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

"""PostCSS run rule.

Runs a internal PostCSS runner, generated via the postcss_gen_runner rule."""

ERROR_INPUT_NO_CSS = "Input of one file must be of a .css file"
ERROR_INPUT_TWO_FILES = "Input of two files must be of a .css and .css.map file"
ERROR_INPUT_TOO_MANY = "Input must be up to two files, a .css file, and optionally a .css.map file"

def _postcss_run_impl(ctx):
    # Get the list of files. Fail here if there are more than two files.
    file_list = ctx.files.src
    if len(file_list) > 2:
        fail(ERROR_INPUT_TOO_MANY)

    # Get the .css and .css.map files from the list, which we expect to always
    # contain a .css file, and optionally a .css.map file.
    css_file = None
    css_map_file = None
    for input_file in file_list:
        if input_file.extension == "css":
            if css_file != None:
                fail(ERROR_INPUT_TWO_FILES)
            css_file = input_file
            continue
        if input_file.extension == "map":
            if css_map_file != None:
                fail(ERROR_INPUT_TWO_FILES)
            css_map_file = input_file
            continue
    if css_file == None:
        fail(ERROR_INPUT_NO_CSS)

    # Generate the command line.
    args = [
        "--cssFile=%s" % css_file.path,
        "--outCssFile=%s" % ctx.outputs.css_file.path,
        "--outCssMapFile=%s" % ctx.outputs.css_map_file.path,
    ]
    if css_map_file:
        args.append("--cssMapFile=%s" % css_map_file.path)

    # The command may only access files declared in inputs.
    inputs = [css_file] + ([css_map_file] if css_map_file else [])

    ctx.actions.run(
        outputs = [ctx.outputs.css_file, ctx.outputs.css_map_file],
        inputs = inputs,
        executable = ctx.executable.runner,
        arguments = args,
        progress_message = "Running PostCSS runner on %s" % ctx.attr.src.label,
    )

def _postcss_run_outputs(output_name):
    output_name = output_name or "%{name}.css"
    return {
        "css_file": output_name,
        "css_map_file": "%s.map" % output_name,
    }

postcss_run = rule(
    implementation = _postcss_run_impl,
    attrs = {
        "src": attr.label(
            allow_files = [".css", ".css.map"],
            mandatory = True,
        ),
        "output_name": attr.string(default = ""),
        "runner": attr.label(
            executable = True,
            cfg = "host",
            allow_files = True,
            mandatory = True,
        ),
    },
    outputs = _postcss_run_outputs,
)

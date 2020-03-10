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

load("//third_party/bazel_skylib/lib:paths.bzl", "paths")

ERROR_INPUT_NO_CSS = "Input of one file must be of a .css file"
ERROR_INPUT_TWO_FILES = "Input of two files must be of a .css and .css.map file"
ERROR_INPUT_TOO_MANY = "Input must be up to two files, a .css file, and optionally a .css.map file"

def _run_one(ctx, input_css, input_map, output_css, output_map):
    """Compile a single CSS file to a single output file."""

    # Generate the command line.
    args = [
        "--binDir=%s" % ctx.bin_dir.path,
        "--cssFile=%s" % input_css.path,
        "--outCssFile=%s" % output_css.path,
        "--outCssMapFile=%s" % output_map.path,
    ]
    if input_map:
        args.append("--cssMapFile=%s" % input_map.path)

    # The command may only access files declared in inputs.
    inputs = [input_css] + ([input_map] if input_map else [])

    ctx.actions.run(
        outputs = [output_css, output_map] + (
            ctx.outputs.additional_outputs if hasattr(ctx.outputs, "additional_outputs") else []
        ),
        inputs = inputs,
        executable = ctx.executable.runner,
        arguments = args,
        progress_message = "Running PostCSS runner on %s" % input_css,
    )

def _postcss_run_impl(ctx):
    # Get the list of files. Fail here if there are more than two files.
    file_list = ctx.files.src
    if len(file_list) > 2:
        fail(ERROR_INPUT_TOO_MANY)

    # Get the .css and .css.map files from the list, which we expect to always
    # contain a .css file, and optionally a .css.map file.
    input_css = None
    input_map = None
    for input_file in file_list:
        if input_file.extension == "css":
            if input_css != None:
                fail(ERROR_INPUT_TWO_FILES)
            input_css = input_file
            continue
        if input_file.extension == "map":
            if input_map != None:
                fail(ERROR_INPUT_TWO_FILES)
            input_map = input_file
            continue
    if input_css == None:
        fail(ERROR_INPUT_NO_CSS)

    _run_one(ctx, input_css, input_map, ctx.outputs.css_file, ctx.outputs.css_map_file)

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
        "additional_outputs": attr.output_list(),
        "runner": attr.label(
            executable = True,
            cfg = "host",
            allow_files = True,
            mandatory = True,
        ),
    },
    outputs = _postcss_run_outputs,
)

def _postcss_multi_run_impl(ctx):
    # A dict from .css filenames to two-element lists which contain
    # [CSS file, soucemap file]. It's an error for a sourcemap to exist
    # without a CSS file, but not vice versa.
    files_by_name = {}
    for f in ctx.files.srcs:
        if f.extension == "map":
            files_by_name.setdefault(_strip_extension(f.path), [None, None])[1] = f
        else:
            files_by_name.setdefault(f.path, [None, None])[0] = f

    outputs = []
    for (input_css, input_map) in files_by_name.values():
        if not input_css:
            fail("Source map file %s was passed without a corresponding CSS file." % input_map.path)

        output_name = ctx.attr.output_pattern.format(
            name = input_css.basename,
            dir = paths.dirname(input_css.short_path),
            rule = ctx.label.name,
        )

        output_css = ctx.actions.declare_file(output_name)
        output_map = ctx.actions.declare_file(output_name + ".map")
        outputs.append(output_css)
        outputs.append(output_map)

        _run_one(ctx, input_css, input_map, output_css, output_map)

    return DefaultInfo(files = depset(outputs))

def _strip_extension(path):
    """Removes the final extension from a path."""
    components = path.split(".")
    components.pop()
    return ".".join(components)

postcss_multi_run = rule(
    implementation = _postcss_multi_run_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".css", ".css.map"],
            mandatory = True,
        ),
        "output_pattern": attr.string(default = "{rule}/{name}"),
        "runner": attr.label(
            executable = True,
            cfg = "host",
            allow_files = True,
            mandatory = True,
        ),
    },
)

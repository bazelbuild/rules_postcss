load("//internal:binary.bzl", "postcss_binary")

postcss_binary(
    name = "style_processed",
    src = "style.css",
    plugins = {
        "postcss-sprites": "[{stylesheetPath: './bazel-out/darwin-fastbuild/bin/examples/postcss-sprites', spritePath: './bazel-out/darwin-fastbuild/bin/examples/postcss-sprites', verbose: true}]",
    },
    data = ["green.png", "red.png"],
    additional_outputs = ["sprite.png"],
    deps = [
        "@npm//postcss-sprites",
    ],
)

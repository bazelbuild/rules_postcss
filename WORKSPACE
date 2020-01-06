workspace(
    name = "build_bazel_rules_postcss",
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "16fc00ab0d1e538e88f084272316c0693a2e9007d64f45529b82f6230aedb073",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.42.2/rules_nodejs-0.42.2.tar.gz"],
)

http_archive(
    name = "io_bazel_rules_sass",
    url = "https://github.com/bazelbuild/rules_sass/archive/1.23.3.zip",
    strip_prefix = "rules_sass-1.23.3",
)

load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
rules_sass_dependencies()

load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
sass_repositories()

load("@build_bazel_rules_nodejs//:defs.bzl", "yarn_install")

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")

install_bazel_dependencies()

# Set up TypeScript toolchain
load("@npm_bazel_typescript//:index.bzl", "ts_setup_workspace")
ts_setup_workspace()

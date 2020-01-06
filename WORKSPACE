workspace(
    name = "build_bazel_rules_postcss",
    managed_directories = {"@npm": ["node_modules"]},
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "e1a0d6eb40ec89f61a13a028e7113aa3630247253bcb1406281b627e44395145",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/1.0.1/rules_nodejs-1.0.1.tar.gz"],
)

http_archive(
    name = "io_bazel_rules_sass",
    sha256 = "617e444f47a1f3e25eb1b6f8e88a2451d54a2afdc7c50518861d9f706fc8baaa",
    urls = [
        "https://github.com/bazelbuild/rules_sass/archive/1.23.7.zip",
        "https://mirror.bazel.build/github.com/bazelbuild/rules_sass/archive/1.23.7.zip",
    ],
    strip_prefix = "rules_sass-1.23.7",
)

load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
rules_sass_dependencies()

load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
sass_repositories()

load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")

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

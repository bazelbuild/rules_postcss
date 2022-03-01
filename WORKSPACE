workspace(
    name = "build_bazel_rules_postcss",
    managed_directories = {"@npm": ["node_modules"]},
)

load("//:package.bzl", "rules_postcss_dependencies")

rules_postcss_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

load("@build_bazel_rules_nodejs//:repositories.bzl", "build_bazel_rules_nodejs_dependencies")

build_bazel_rules_nodejs_dependencies()

load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

load("//:repositories.bzl", "postcss_repositories")

postcss_repositories()

workspace(
    name = "build_bazel_rules_postcss",
    managed_directories = {"@npm": ["node_modules"]},
)

load("//:package.bzl", "rules_postcss_dependencies")
rules_postcss_dependencies()

load("@build_bazel_rules_nodejs//:index.bzl", "yarn_install")
yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

load("@npm//:install_bazel_dependencies.bzl", "install_bazel_dependencies")
install_bazel_dependencies()

load("//:repositories.bzl", "postcss_repositories")
postcss_repositories()

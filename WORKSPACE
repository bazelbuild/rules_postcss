workspace(name = "build_bazel_rules_postcss")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "e04a82a72146bfbca2d0575947daa60fda1878c8d3a3afe868a8ec39a6b968bb",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.31.1/rules_nodejs-0.31.1.tar.gz"],
)

http_archive(
    name = "io_bazel_rules_sass",
    url = "https://github.com/bazelbuild/rules_sass/archive/9a00e557c32ac0f26e5d3c66d1d17316874027b3.zip",
    strip_prefix = "rules_sass-9a00e557c32ac0f26e5d3c66d1d17316874027b3",
    sha256 = "f404a88872c5ffe9af7f5d54be35add624164b852c29c265843ba172bb0c7ac4",
    # TODO: Switch to next minor release of rules_sass.
    # url = "https://github.com/bazelbuild/rules_sass/archive/1.21.0.zip",
    # strip_prefix = "rules_sass-1.21.0",
)

load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
rules_sass_dependencies()

load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
sass_repositories()

load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories", "yarn_install")

node_repositories(package_json = ["//:package.json"])

yarn_install(
    name = "npm",
    package_json = "//:package.json",
    yarn_lock = "//:yarn.lock",
)

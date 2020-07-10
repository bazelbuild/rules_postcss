[![Build status](https://badge.buildkite.com/bc5333505517af47aba68c0c464f17a8e596338b742e6df295.svg)](https://buildkite.com/bazel/rules-postcss)

# PostCSS Rules for Bazel

## Rules

*   postcss_binary
*   postcss_multi_binary
*   postcss_plugin
*   autoprefixer

## Overview

These build rules are used for post-processing CSS files via [PostCSS][postcss]
with Bazel.

[postcss]: https://postcss.org

## Setup

### Using npm and Node.js rules

We recommend you use npm to install the PostCSS build rules if you use the
[Node.js build rules][rules_nodejs], and **strongly recommend** using npm
if you also depend or plan to depend on PostCSS in your local `package.json`.
(For example, if PostCSS plugin(s) will form part of your repository's build
pipeline.)

Installing the PostCSS build rules via npm allows you to rely on its native
package management functionality. If you depend on PostCSS in your local
`package.json`, using npm also helps avoid version skew between PostCSS in
your repository and these build rules.

[rules_nodejs]: https://bazelbuild.github.io/rules_nodejs/

Add the `@bazel/postcss` npm package to your `devDependencies` in
`package.json`.

Your `WORKSPACE` should declare a `yarn_install` or `npm_install` rule named
`npm`.
See https://github.com/bazelbuild/rules_nodejs/#quickstart

This causes the build rules to be made available under
`@npm//@bazel/postcss:defs.bzl`.

**TODO:** Compare to using PostCSS directly using `rules_nodejs`.

### Using repository rules

Add the following to your WORKSPACE file to add the external repositories for
PostCSS, making sure to use the latest published versions:

```python
http_archive(
    name = "build_bazel_rules_postcss",
    # Make sure to check for the latest version when you install
    url = "https://github.com/bazelbuild/rules_postcss/archive/NOT_PUBLISHED_YET.zip",
    strip_prefix = "NOT_PUBLISHED_YET",
    sha256 = "NOT_PUBLISHED_YET",
)
```

This causes the build rules to be made available under
`@build_bazel_rules_postcss//:index.bzl`.

## Basic Example

To be documented.

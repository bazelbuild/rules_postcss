# For Developers

This repo is in early stages of development, so these instructions are subject to change.

## Releasing

Start from a clean checkout at master/HEAD.

Googlers: you should npm login using the go/npm-publish service: `$ npm login --registry https://wombat-dressing-room.appspot.com`

1. `npm version [major|minor|patch]` (`major` if there are breaking changes, `minor` if there are new features, otherwise `patch`)
1. If publishing from inside Google, set NPM_REGISTRY="--registry https://wombat-dressing-room.appspot.com" in your environment
1. Build the npm package and publish it: `bazel run //:npm_package.pack`

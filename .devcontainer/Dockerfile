FROM launcher.gcr.io/google/nodejs

# We are not running in prod. Allow yarn to fetch devDependencies.
ENV NODE_ENV development

# Use Bazelisk to fetch Bazel specified in .bazelversion. Also install Buildifier.
RUN yarn global add @bazel/bazelisk @bazel/buildifier

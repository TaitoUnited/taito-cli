# Docker builds and artifact reuse

The Docker plugin builds and loads the builder image first, then builds and loads
the runtime image using the currently selected Buildx builder. Keep a builder
that can resolve images in the Docker daemon's image store when a Dockerfile uses
`FROM <project>-<target>-builder:${BUILD_IMAGE_TAG}`. The plugin does not change
Buildx drivers.

Both builds embed inline BuildKit cache metadata. When
`taito_ci_pull_docker_cache` is not `false`, the plugin pulls and imports the
target's builder and runtime `:latest` images as optional caches and publishes
those cache images after building. Missing caches allow a cold build. The first
build after upgrading must publish these images before fresh CI builders can use
the new metadata. Inline caching does not export package-manager cache mounts or
all intermediate stages of an arbitrary multi-stage Dockerfile.

Revision-specific `<registry>/<target>-builder:<image-tag>` images are required
artifacts for tests and build reuse. They are published to remote registries even
when optional caching is disabled. Reuse pulls this exact builder revision and
the requested runtime, then creates the local builder/tester aliases. It never
substitutes `builder:latest` for a missing revision. Missing required artifacts
or failed local tags fail after 80 attempts, with 30 seconds between attempts.
Rebuild older revisions once if they predate publication of revision-specific
builders.

`taito_ci_cache_all_targets_with_docker` additionally enables Docker publication
for non-container targets in `artifact-prepare`; it is separate from the optional
cache switch.

Run the regression tests with `bats plugins/docker/build.bats`. These tests stub
Docker and sleep calls and require no registry or Docker daemon.

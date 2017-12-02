#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_registry:?}"
: "${taito_env:?}"

name=${1:?Name not given}
image_tag=${2:-dry-run}
image_path=${3}

path_suffix=""
tag_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
  tag_suffix="-${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

# Read version number that semantic-release wrote on the package.json
version=$(grep "version" "${taito_project_path}/package.json" | \
  grep -o "[0-9].[0-9].[0-9]")

if [[ ! -f ./taitoflag_images_exist ]]; then
  echo "- Building image"
  docker build -f "./${name}/Dockerfile.build" \
    --build-arg BUILD_VERSION="${version}" \
    --build-arg BUILD_IMAGE_TAG="${image_tag}" \
    -t "${image_path}${path_suffix}:${image_tag}" "./${name}"
else
  echo "- Image ${image_tag} already exists. Pulling the existing image."
  # We have pull the image so that it exists at the end
  docker pull "${image_path}${path_suffix}:${image_tag}"
fi && \

# Tag so that CI will not rebuild image when running docker-compose
if [[ "${taito_mode:-}" == "ci" ]]; then
  echo "tag for ci-test: workspace_${taito_project}${tag_suffix}:latest" && \
  echo "tag for ci-test: ${taito_project//-/}_${taito_project}${tag_suffix}:latest" && \
  echo "tag for ci-test: ${taito_project}${tag_suffix}:latest" && \
  echo "pwd: ${PWD}" && \
  echo "project path: ${taito_project_path}" && \
  docker image tag "${image_path}${path_suffix}:${image_tag}" \
    "workspace_${taito_project}${tag_suffix}:latest" && \
  docker image tag "${image_path}${path_suffix}:${image_tag}" \
    "${taito_project//-/}_${taito_project}${tag_suffix}:latest" && \
  docker image tag "${image_path}${path_suffix}:${image_tag}" \
    "${taito_project}${tag_suffix}:latest"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

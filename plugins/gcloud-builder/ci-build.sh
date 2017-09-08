#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_registry:?}"
: "${taito_env:?}"

name=${1:?Name not given}
image_tag=${2:-dry-run}
image_path=${3}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

# Read version number that semantic-release wrote on the package.json
version=$(grep "version" "${taito_project_path}/package.json" | \
  grep -o "[0-9].[0-9].[0-9]")

echo
echo "### gcloud-builder - ci-build: Building ${name} ###"
echo

if [[ ${taito_image_exists:-false} == false ]]; then
  echo "- Building image"
  docker build -f "./${name}/Dockerfile.build" \
    --build-arg BUILD_VERSION="${version}" \
    --build-arg BUILD_IMAGE_TAG="${image_tag}" \
    -t "${image_path}/${name}:${image_tag}" "./${name}" && \
  if [[ "${taito_mode:-}" == "ci" ]]; then
    # Tag so that CI will not rebuild image when running docker-compose
    docker image tag "${image_path}/${name}:${image_tag}" \
      "${taito_project//-/}_${taito_project}-${name}"
  fi && \
  if [[ ${image_tag} != 'dry-run' ]]; then
    echo "- Pushing image"
    docker push "${image_path}/${name}:${image_tag}"
  fi
else
  echo "- Image ${image_tag} already exists. Pulling the existing image."
  # We have pull the image so that it exists at the end
  docker pull "${image_path}/${name}:${image_tag}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

name=${1}
image_tag=${2:-dry-run}
image_path=${3}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

# Read version number that semantic-release wrote on the package.json
version=$(grep "version" "${taito_project_path}/package.json" | grep -o "[0-9].[0-9].[0-9]")

echo
echo "### gcloud-builder - build: Building ${name} ###"
echo

if [[ ${taito_image_exists:-false} == false ]]; then
  echo "- Building image"
  docker build -f "./${name}/Dockerfile.build" \
    --build-arg BUILD_VERSION="${version}" \
    --build-arg BUILD_IMAGE_TAG="${image_tag}" \
    -t "${image_path}/${name}:${image_tag}" "./${name}"
  if [[ $? -gt 0 ]]; then
    exit 1
  fi
  if [[ ${image_tag} == 'dry-run' ]]; then
    exit 0
  fi
  echo "- Pushing image"
  if ! docker push "${image_path}/${name}:${image_tag}"; then
    exit 1
  fi
else
  echo "- Image ${image_tag} already exists. Pulling the existing image."
  # We have pull the image so that it exists at the end
  if ! docker pull "${image_path}/${name}:${image_tag}"; then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

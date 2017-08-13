#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_image_exists:?}"

name=${1}
image_tag=${2}
image_path=${3}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

# TODO read BUILD_VERSION from package.json
version="x.x.x"

echo
echo "### gcloud-builder - build: Building ${name} ###"
echo

if [[ ${taito_image_exists} == false ]]; then
  echo "- Building image"
  docker build -f "./${name}/Dockerfile.build" \
    --build-arg BUILD_VERSION="${version}" \
    --build-arg BUILD_IMAGE_TAG="${image_tag}" \
    -t "${image_path}/${name}:${image_tag}" "./${name}"
  if [[ $? -gt 0 ]]; then
    exit 1
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

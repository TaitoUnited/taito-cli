#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_registry:?}"
: "${taito_env:?}"

name=${1:?Name not given}
image_tag=${2:?Image tag not given}
image_path=${3}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

echo
echo "### gcloud-builder - ci-push: Pushing ${name} ###"

if [[ ! -f ./taitoflag_images_exist ]]; then
  docker push "${image_path}/${name}:${image_tag}"
else
  echo "- Image ${image_tag} already exists. Skipping push."
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

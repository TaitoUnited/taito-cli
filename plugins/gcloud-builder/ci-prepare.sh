#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"
: "${taito_registry:?}"

name=${1:?Name not given}
image_tag=${2}
image_path=${3}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

echo
echo "### gcloud-builder - ci-prepare: Checking if image already exists \
in the container registry ###"
echo "TODO check from container registry instead as there might be manual \
builds also"

check=$(gcloud beta container builds list --limit=1 \
  --filter="STATUS=SUCCESS AND IMAGES=${image_path}/${name}:${image_tag}" \
  | grep "${image_tag}")

export taito_images_exist
if [[ ${check} == "" ]]; then
  echo "Image does not exist"
  taito_images_exist=false
else
  echo "Image exists"
  taito_images_exist=true
  cat "exist" > ./taitoflag_images_exist
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

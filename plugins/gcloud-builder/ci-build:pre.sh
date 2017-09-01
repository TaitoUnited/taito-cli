#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"

name=${1}
image_tag=${2}
image_path=${3}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

echo
echo "### gcloud-builder - build:pre: Checking if image exists already in the container registry ###"
echo
echo "TODO check from container registry instead as there might be manual builds also"

check=$(gcloud beta container builds list --limit=1 \
  --filter="STATUS=SUCCESS AND IMAGES=${image_path}/${name}:${image_tag}" \
  | grep "${image_tag}")

export taito_image_exists
if [[ ${check} == "" ]]; then
  taito_image_exists=false
else
  taito_image_exists=true
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

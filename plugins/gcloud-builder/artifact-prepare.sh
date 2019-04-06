#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"
: "${taito_image_registry:?}"

image_tag=${1}
image_path=${2}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_image_registry}"
fi

echo "Checking if image already exists in the container registry"
echo "TODO check from container registry instead as there might be manual \
builds also"

check=$( \
  gcloud -q builds list --limit=1 \
  --filter="status:SUCCESS AND \
            source.repoSource.repoName~.*${taito_project:?} AND \
            images~.*\\:${image_tag}" \
)

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

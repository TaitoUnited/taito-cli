#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"
: "${taito_container_registry:?}"
: "${taito_zone:?}"

image_tag=${1}
image_path=${2}

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_container_registry}"
fi

echo "Checking if image already exists in the container registry"
echo "TODO check from container registry instead as there might be manual \
builds also"

check=$( \
  gcloud -q --project "${taito_zone}" builds list \
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
  echo "exist" > ./taitoflag_images_exist
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

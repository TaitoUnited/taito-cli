#!/bin/bash
: "${taito_util_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_container_registry:?}"
: "${taito_env:?}"

name=${taito_target:?Target not given}
image_tag=${1:?Image tag not given}
image_path=${2}

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_container_registry}"
fi

prefix="${image_path}${path_suffix}"
image="${prefix}:${image_tag}"

echo "image: ${image}"

if [[ -f ./taitoflag_images_exist ]]; then
  echo "Skipping artifact release. Image already exists in registry."
elif [[ "${taito_targets:-}" != *"${name}"* ]]; then
  echo "Skipping artifact release. Artifact ${name} not included in taito_targets."
else
  if [[ -f "${name}.docker" ]]; then
    echo "Load ${name}.docker"
    (${taito_setv:?}; docker load --input "${name}.docker")
  fi
  echo "Push ${image}"
  "$taito_plugin_path/util/imagepush.sh" "${image}"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

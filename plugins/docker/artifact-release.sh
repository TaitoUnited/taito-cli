#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_image_registry:?}"
: "${taito_env:?}"

name=${taito_target:?Target not given}
image_tag=${1:?Image tag not given}
image_path=${2}

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_image_registry}"
fi

prefix="${image_path}${path_suffix}"
image="${prefix}:${image_tag}"

echo "image: ${image}"

if [[ "${taito_targets:-}" != *"${name}"* ]]; then
  echo "Skipping artifact release: ${name} not included in taito_targets"
else
  if [[ -f "${name}.docker" ]]; then
    echo "Load ${name}.docker"
    (${taito_setv:?} docker load --input "${name}.docker")
  fi
  echo "Push ${image}"
  (${taito_setv:?} docker push "${image}")
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

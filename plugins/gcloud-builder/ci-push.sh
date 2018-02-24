#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_registry:?}"
: "${taito_env:?}"

name=${1:?Name not given}
image_tag=${2:?Image tag not given}
image_path=${3}

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

if [[ "${ci_stack:-}" != *"${name}"* ]]; then
  echo "Skipping push: ${name} not included in ci_stack"
else
  if [[ ! -f ./taitoflag_images_exist ]]; then
    (${taito_setv:?}; docker push "${image_path}${path_suffix}:${image_tag}")
  else
    echo "- Image ${image_tag} already exists. Skipping push."
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

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

if [[ "${taito_targets:-}" != *"${name}"* ]]; then
  echo "Skipping verify: ${name} not included in taito_targets"
else
  (
    ${taito_setv:?}
    # push image without the -untested prefix
    docker push "${image}"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_registry:?}"
: "${taito_env:?}"

name=${taito_target:?Target not given}
image_tag=${1:?Image tag not given}
image_path=${2}

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

version=$(cat "${taito_project_path}/taitoflag_version" 2> /dev/null)

prefix="${image_path}${path_suffix}"
image="${prefix}:${image_tag}"
image_untested="${image}-untested"
image_latest="${prefix}:latest"
image_builder="${prefix}-builder:latest"

if [[ "${taito_targets:-}" != *"${name}"* ]]; then
  echo "Skipping push: ${name} not included in taito_targets"
else
  if [[ ! -f ./taitoflag_images_exist ]] && \
     ([[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_build:-}" == "true" ]])
  then
    (
      ${taito_setv:?}
      docker push "${image_untested}" && \
      docker push "${image_latest}" && \
      docker push "${image_builder}"
    )
  else
    echo "- Image ${image_tag} already exists. Skipping push."
  fi && \
  if [[ "${version}" ]]; then
    echo "- Tagging an existing image with semantic version ${version}"
    (
      ${taito_setv:?}
      docker image tag "${image}" "${prefix}:${version}" && \
      docker push "${prefix}:${version}"
    )
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

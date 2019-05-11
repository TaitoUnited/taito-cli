#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_container_registry:?}"
: "${taito_env:?}"

name=${taito_target:?Target not given}
image_tag=${1:?Image tag not given}
if [[ "${taito_docker_new_params:-}" == "true" ]]; then
  save_image=${2}
  build_context=${3}
  service_dir=${4}
  dockerfile=${5}
  image_path=${6}
else
  image_path=${2}
fi

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_container_registry}"
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
    "$taito_plugin_path/imagepush.sh" "${image_untested}" && \
    "$taito_plugin_path/imagepush.sh" "${image_latest}" && \
    "$taito_plugin_path/imagepush.sh" "${image_builder}"
  else
    echo "- Image ${image_tag} already exists. Skipping push."
  fi && \
  if [[ "${version}" ]]; then
    echo "- Tagging an existing image with semantic version ${version}"
    (
      (${taito_setv:?}; docker image tag "${image}" "${prefix}:${version}") && \
      "$taito_plugin_path/imagepush.sh" "${prefix}:${version}"
    )
  fi
fi

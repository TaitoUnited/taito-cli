#!/bin/bash

function docker::image_pull () {
  if [[ ${taito_container_registry_provider:-} != "local" ]]; then
    (
      taito::executing_start
      docker pull "$1"
    )
  fi
  # TODO: docker pull for host registry provider?
}

function docker::image_push () {
  echo
  if [[ ${taito_container_registry_provider:-} != "local" ]]; then
    echo "Pushing image $1 to registry. This may take some time. Please be patient."
    (
      taito::executing_start
      docker push "$1"
    )
  else
    taito::expose_ssh_opts
    echo "Pushing image $1 to registry. This may take some time. Please be patient."
    (
      taito::executing_start
      # TODO add users to docker group to avoid sudo?
      docker save "$1" | \
        ssh ${ssh_opts} -C "${taito_ssh_user:?}@${taito_host:?}" sudo docker load
    )
  fi
}

function docker::push () {
  : "${taito_project_path:?}"
  : "${taito_container_registry:?}"

  local name=${taito_target:?Target not given}
  local image_tag=${1:?Image tag not given}
  if [[ ${taito_docker_new_params:-} == "true" ]]; then
    local save_image=${2}
    local build_context=${3}
    local service_dir=${4}
    local dockerfile=${5}
    local image_path=${6}
  else
    local image_path=${2}
  fi

  local path_suffix=""
  if [[ ${name} != "." ]]; then
    path_suffix="/${name}"
  fi

  if [[ ${image_path} == "" ]]; then
    image_path="${taito_container_registry}"
  fi

  local version=$(cat "${taito_project_path}/taitoflag_version" 2> /dev/null)

  local prefix="${image_path}${path_suffix}"
  local image="${prefix}:${image_tag}"
  local image_untested="${image}-untested"
  local image_latest="${prefix}:latest"
  local image_builder="${prefix}-builder:latest"

  if [[ ${taito_targets:-} != *"${name}"* ]]; then
    echo "Skipping push: ${name} not included in taito_targets"
  else
    if [[ ! -f ./taitoflag_images_exist ]] && \
       ([[ ${taito_mode:-} != "ci" ]] || [[ ${ci_exec_build:-} == "true" ]])
    then
      docker::image_push "${image_untested}"
      if [[ ${taito_container_registry_provider:-} != "local" ]]; then
        docker::image_push "${image_latest}"
        docker::image_push "${image_builder}"
      fi
    else
      echo "- Image ${image_tag} already exists. Skipping push."
    fi
    if [[ ${version} ]]; then
      echo "- Tagging an existing image with semantic version ${version}"
      (
        (taito::executing_start; docker image tag "${image}" "${prefix}:${version}")
        docker::image_push "${prefix}:${version}"
      )
    fi
  fi
}

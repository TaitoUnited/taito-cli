#!/bin/bash

function docker::build () {
  : "${taito_plugin_path:?}"
  : "${taito_project:?}"
  : "${taito_project_path:?}"
  : "${taito_container_registry:?}"
  : "${taito_target_env:?}"
  : "${taito_env:?}"

  local name=${taito_target:?Target not given}
  local image_tag=${1:-dry-run}
  if [[ "${taito_docker_new_params:-}" == "true" ]]; then
    local save_image=${2}
    local build_context=${3}
    local service_dir=${4}
    local dockerfile=${5}
    local image_path=${6}
  else
    local build_context=${2}
    local service_dir=${3}
    local dockerfile=${4}
    local image_path=${5}
  fi

  # NOTE: For backwards compatibility
  if [[ "${2}" == "eu.gcr.io"* ]]; then
    local image_path=${2}
    local build_context=${3}
    local service_dir=${4}
  fi

  # NOTE: For backwards compatibility
  if [[ "${4}" == "eu.gcr.io"* ]]; then
    local image_path=${4}
    local dockerfile=""
  fi

  if [[ "${build_context}" == "" ]]; then
    local build_context="./${name}"
  fi

  if [[ "${service_dir}" == "" ]]; then
    local service_dir="./${name}"
  fi

  if [[ "${image_path}" == "" ]]; then
    local image_path="${taito_container_registry}"
  fi

  local path_suffix=""
  if [[ "${name}" != "." ]]; then
    path_suffix="/${name}"
  fi

  local prefix="${image_path}${path_suffix}"
  local image="${prefix}:${image_tag}"
  local image_untested="${image}-untested"
  local image_latest="${prefix}:latest"
  local image_builder="${prefix}-builder:latest"
  local image_tester="${taito_project}-${name}-tester:latest"

  if [[ "${taito_targets:-}" != *"${name}"* ]]; then
    echo "Skipping build: ${name} not included in taito_targets"
  else
    if [[ -f ./taitoflag_images_exist ]] || \
       ([[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_build:-}" == "false" ]])
    then
      # Image should exist.
      # We have to pull the existing image so that it exists at the end
      # We also pull the builder image for integration tests
      local count=0
      local pulled="false"
      while true
      do
        echo "- Pulling the existing image ${image_tag}."
        (
          ${taito_setv:?};
          "$taito_plugin_path/util/imagepull" "${image}"
          "$taito_plugin_path/util/imagepull" "${image_builder}"
          docker image tag "${image_builder}" "${image_tester}"
        ) && pulled="true"
        if [[ $pulled == "true" ]]; then
          break
        elif [[ $count -gt 80 ]]; then
          echo "- ERROR: Image ${image_tag} not found from registry even after multiple retries. Not building a new image because ci_exec_build is set to '${ci_exec_build}' for '${taito_target_env}' environment."
          exit 1
        else
          echo "- WARNING: Image ${image_tag} not found from registry. Not building a new image because ci_exec_build is set to '${ci_exec_build}' for '${taito_target_env}' environment. Retry in 30 secs."
          sleep 30
        fi
      done
    else
      # Image does not exist. Build it.
      echo "- Building image"

      if [[ -z "${dockerfile}" ]]; then
        if [[ -f "${service_dir}/Dockerfile.build" ]]; then
          dockerfile="Dockerfile.build"
        else
          dockerfile="Dockerfile"
        fi
      fi

      if [[ -d "./shared" ]]; then
        shared_dest="${service_dir}/shared"
        if [[ -L "${service_dir}/src/shared" ]]; then
          shared_dest="${service_dir}/src/shared"
        fi
        if [[ -L "${shared_dest}" ]]; then
          rm -rf "${shared_dest}"
        fi
        if [[ ! -f "${shared_dest}" ]] && [[ ! -d "${shared_dest}" ]]; then
          echo "Mapping ./shared to ${shared_dest}"
          cp -r ./shared "${shared_dest}"
        fi
      fi

      (
        # Pull latest builder and production image to be used as cache
        "$taito_plugin_path/util/imagepull" "${image_builder}"
        "$taito_plugin_path/util/imagepull" "${image_latest}"
        # Build the build stage container separately so that it can be used as:
        # 1) Build cache for later builds using --cache-from
        # 2) Integration and e2e test executioner
        ${taito_setv:?}
        docker build \
          --target builder \
          -f "${service_dir}/${dockerfile}" \
          --build-arg BUILD_VERSION="UNKNOWN" \
          --build-arg BUILD_IMAGE_TAG="${image_tag}" \
          --cache-from "${image_builder}" \
          --tag "${image_builder}" \
          --tag "${image_tester}" \
          "${build_context}"
        # Build the production runtime
        # TODO use also latest production container as cache?
        docker build \
          -f "${service_dir}/${dockerfile}" \
          --cache-from "${image_builder}" \
          --cache-from "${image_latest}" \
          --build-arg BUILD_VERSION="UNKNOWN" \
          --build-arg BUILD_IMAGE_TAG="${image_tag}" \
          --tag "${image}" \
          --tag "${image_untested}" \
          --tag "${image_latest}" \
          "${build_context}"
      )
    fi
    if [[ ${save_image} == "true" ]]; then
      (
        ${taito_setv:?}
        docker save --output "${name}-tester.docker" "${image_tester}"
        docker save --output "${name}.docker" "${image}"
        pwd
        ls *.docker
      )
    fi
  fi
}

function docker::image_pull () {
  if [[ ${taito_container_registry_provider:-} != "local" ]]; then
    (
      ${taito_setv:?}
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
      ${taito_setv:?}
      docker push "$1"
    )
  else
    taito::expose_ssh_opts
    echo "Pushing image $1 to registry. This may take some time. Please be patient."
    (
      ${taito_setv:?}
      # TODO add users to docker group to avoid sudo?
      docker save "$1" | \
        ssh ${ssh_opts} -C "${taito_ssh_user:?}@${taito_host:?}" sudo docker load
    )
  fi
}

function docker::push () {
  : "${taito_plugin_path:?}"
  : "${taito_project:?}"
  : "${taito_project_path:?}"
  : "${taito_container_registry:?}"
  : "${taito_env:?}"

  local name=${taito_target:?Target not given}
  local image_tag=${1:?Image tag not given}
  if [[ "${taito_docker_new_params:-}" == "true" ]]; then
    local save_image=${2}
    local build_context=${3}
    local service_dir=${4}
    local dockerfile=${5}
    local image_path=${6}
  else
    local image_path=${2}
  fi

  local path_suffix=""
  if [[ "${name}" != "." ]]; then
    path_suffix="/${name}"
  fi

  if [[ "${image_path}" == "" ]]; then
    image_path="${taito_container_registry}"
  fi

  local version=$(cat "${taito_project_path}/taitoflag_version" 2> /dev/null)

  local prefix="${image_path}${path_suffix}"
  local image="${prefix}:${image_tag}"
  local image_untested="${image}-untested"
  local image_latest="${prefix}:latest"
  local image_builder="${prefix}-builder:latest"

  if [[ "${taito_targets:-}" != *"${name}"* ]]; then
    echo "Skipping push: ${name} not included in taito_targets"
  else
    if [[ ! -f ./taitoflag_images_exist ]] && \
       ([[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_build:-}" == "true" ]])
    then
      "$taito_plugin_path/util/imagepush" "${image_untested}"
      if [[ ${taito_container_registry_provider:-} != "local" ]]; then
        "$taito_plugin_path/util/imagepush" "${image_latest}"
        "$taito_plugin_path/util/imagepush" "${image_builder}"
      fi
    else
      echo "- Image ${image_tag} already exists. Skipping push."
    fi
    if [[ "${version}" ]]; then
      echo "- Tagging an existing image with semantic version ${version}"
      (
        (${taito_setv:?}; docker image tag "${image}" "${prefix}:${version}")
        "$taito_plugin_path/util/imagepush" "${prefix}:${version}"
      )
    fi
  fi
}

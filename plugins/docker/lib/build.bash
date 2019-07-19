#!/bin/bash

function docker::build () {
  : "${taito_project:?}"
  : "${taito_project_path:?}"
  : "${taito_container_registry:?}"
  : "${taito_target_env:?}"
  : "${taito_env:?}"

  local name=${taito_target:?Target not given}
  local image_tag=${1:-dry-run}
  if [[ ${taito_docker_new_params:-} == "true" ]]; then
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

  if [[ ${build_context} == "" ]]; then
    local build_context="./${name}"
  fi

  if [[ ${service_dir} == "" ]]; then
    local service_dir="./${name}"
  fi

  if [[ ${image_path} == "" ]]; then
    local image_path="${taito_container_registry}"
  fi

  local path_suffix=""
  if [[ ${name} != "." ]]; then
    path_suffix="/${name}"
  fi

  local prefix="${image_path}${path_suffix}"
  local image="${prefix}:${image_tag}"
  local image_untested="${image}-untested"
  local image_latest="${prefix}:latest"
  local image_builder="${prefix}-builder:latest"
  local image_tester="${taito_project}-${name}-tester:latest"

  if [[ ${taito_targets:-} != *"${name}"* ]]; then
    echo "Skipping build: ${name} not included in taito_targets"
  else
    if [[ -f ./taitoflag_images_exist ]] || \
       ([[ ${taito_mode:-} == "ci" ]] && [[ ${ci_exec_build:-} == "false" ]])
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
          set +e
          taito::executing_start;
          docker::image_pull "${image}" && \
          docker::image_pull "${image_builder}" && \
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
        docker::image_pull "${image_builder}" || :
        docker::image_pull "${image_latest}" || :
        # Build the build stage container separately so that it can be used as:
        # 1) Build cache for later builds using --cache-from
        # 2) Integration and e2e test executioner
        taito::executing_start
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
        taito::executing_start
        docker save --output "${name}-tester.docker" "${image_tester}"
        docker save --output "${name}.docker" "${image}"
        pwd
        ls *.docker
      )
    fi
  fi
}

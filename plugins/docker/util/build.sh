#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_container_registry:?}"
: "${taito_target_env:?}"
: "${taito_env:?}"

name=${taito_target:?Target not given}
image_tag=${1:-dry-run}
if [[ "${taito_docker_new_params:-}" == "true" ]]; then
  save_image=${2}
  build_context=${3}
  service_dir=${4}
  dockerfile=${5}
  image_path=${6}
else
  build_context=${2}
  service_dir=${3}
  dockerfile=${4}
  image_path=${5}
fi

# NOTE: For backwards compatibility
if [[ "${2}" == "eu.gcr.io"* ]]; then
  image_path=${2}
  build_context=${3}
  service_dir=${4}
fi

# NOTE: For backwards compatibility
if [[ "${4}" == "eu.gcr.io"* ]]; then
  image_path=${4}
  dockerfile=""
fi

if [[ "${build_context}" == "" ]]; then
  build_context="./${name}"
fi

if [[ "${service_dir}" == "" ]]; then
  service_dir="./${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_container_registry}"
fi

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

prefix="${image_path}${path_suffix}"
image="${prefix}:${image_tag}"
image_untested="${image}-untested"
image_latest="${prefix}:latest"
image_builder="${prefix}-builder:latest"
image_tester="${taito_project}-${name}-tester:latest"

if [[ "${taito_targets:-}" != *"${name}"* ]]; then
  echo "Skipping build: ${name} not included in taito_targets"
else
  if [[ -f ./taitoflag_images_exist ]] || \
     ([[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_build:-}" == "false" ]])
  then
    # Image should exist.
    # We have to pull the existing image so that it exists at the end
    # We also pull the builder image for integration tests
    count=0
    pulled="false"
    while true
    do
      echo "- Pulling the existing image ${image_tag}."
      (
        ${taito_setv:?};
        "$taito_plugin_path/util/imagepull.sh" "${image}" && \
        "$taito_plugin_path/util/imagepull.sh" "${image_builder}" && \
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
      cp -r ./shared ${service_dir}
    fi

    (
      # Pull latest builder and production image to be used as cache
      "$taito_plugin_path/util/imagepull.sh" "${image_builder}"
      "$taito_plugin_path/util/imagepull.sh" "${image_latest}"
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
        "${build_context}" && \
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
  fi && \
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

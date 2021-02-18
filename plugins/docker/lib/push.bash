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
      # TODO: remove hardcoded -untested prefix hack
      image_tag="$1"
      if [[ ${image_tag} == *"-untested" ]]; then
        echo 1 $image_tag
        docker save "${image_tag}" | \
          ssh ${ssh_opts} -C "${taito_ssh_user:?}@${taito_host:?}" ${LINUX_SUDO} docker load
      else
        echo 2 $image_tag
        ssh ${ssh_opts} "${taito_ssh_user}@${taito_host}" "
          ${LINUX_SUDO} bash -c '
            set -e
            ${taito_setv:-}
            docker tag ${image_tag}-untested ${image_tag}
          '
        "
      fi
    )
  fi
}

function docker::push () {
  : "${taito_project_path:?}"
  : "${taito_container_registry:?}"

  # REFACTOR: duplicate code with docker::build and docker::package
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
    echo "ERROR: ${name} not included in taito_targets"
    exit 1
  else
    if [[ ! -f ./taitoflag_images_exist ]] && \
       ([[ ${taito_mode:-} != "ci" ]] || [[ ${ci_exec_build:-} == "true" ]])
    then
      echo "- Pushing images"
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

function docker::package () {
  : "${taito_project_path:?}"
  : "${taito_container_registry:?}"

  # REFACTOR: duplicate code with docker::build and docker::push
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

  local prefix="${image_path}${path_suffix}"
  local image="${prefix}:${image_tag}"
  local image_untested="${image}-untested"

  # TODO: how to avoid hard coded base href? Perhaps does not matter, since you
  # can hard code base href in container implementation if it becomes a problem.
  local basePath="/${taito_target}"
  if [[ ${taito_target} == "client" ]]; then
    basePath=""
  fi
  local assetsPath="${basePath}"
  if [[ ${taito_cdn_project_path:-} ]] &&
     [[ ${taito_cdn_project_path} != "-"* ]]; then
    assetsPath="${taito_cdn_project_path}/${image_tag}/${taito_target}"
  fi
  local assetsDomain="${taito_cdn_domain:-}"

  if [[ ${taito_targets:-} != *"${name}"* ]]; then
    echo "ERROR: ${name} not included in taito_targets"
    exit 1
  else
    # Copy and package files
    (
      echo "Packaging ./tmp/${taito_target}.zip for deployment"
      taito::executing_start
      mkdir -p "./tmp/${taito_target}"
      docker run \
        --user 0:0 \
        -v "${PWD}/tmp/${taito_target}:/tmp/${taito_target}" \
        --entrypoint /bin/sh \
        "${image_untested}" \
        -c "cp -r /service /tmp/${taito_target}"
      cd "./tmp/${taito_target}/service"

      # Replace BASE_PATH, ASSETS_DOMAIN, and ASSETS_PATH in source files
      find . -name '*.html' -exec sed -i -e \
        "s/BASE_PATH/${basePath//\//\\/}/g" {} \;
      find . -name '*.html' -exec sed -i -e \
        "s/ASSETS_DOMAIN/${assetsDomain//\//\\/}/g" {} \;
      find . -name '*.html' -exec sed -i -e \
        "s/ASSETS_PATH/${assetsPath//\//\\/}/g" {} \;
      find . -name 'runtime.*.js' -exec sed -i -e \
        "s/ASSETS_PATH/${assetsPath//\//\\/}/g" {} \;
      find . -name 'manifest.json' -exec sed -i -e \
        "s/ASSETS_PATH/${assetsPath//\//\\/}/g" {} \;
      find . -name 'manifest.json' -exec sed -i -e \
        "/start_url/d" {} \;

      # Create zip package
      zip -rq "../../${taito_target}.zip" .* *
    )
  fi
}

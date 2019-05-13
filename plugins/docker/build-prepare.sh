#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"
: "${taito_container_registry:?}"

image_tag=${1}

if [[ ${taito_container_registry_provider:-} == "host" ]]; then
  . "${taito_cli_path}/plugins/ssh/util/opts.sh"

  images=$(
    ssh ${opts} "${taito_ssh_user}@${taito_host}" "
      sudo bash -c '
        sudo docker images | grep ${taito_container_registry} | grep [[:space:]]${image_tag}[[:space:]]
      '
    "
  )

  if [[ ${images} ]]; then
    echo "exist" > ./taitoflag_images_exist
    echo "Images already exist on host:"
    echo "${images}"
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

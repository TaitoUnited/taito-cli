#!/bin/bash

echo
if [[ ${taito_container_registry_provider:-} != "local" ]]; then
  echo "Pushing image $1 to registry. This may take some time. Please be patient..."
  (
    ${taito_setv:?}
    docker push "$1"
  )
else
  . "${taito_cli_path}/plugins/ssh/util/opts.sh"
  echo "Pushing image $1 to registry. This may take some time. Please be patient..."
  (
    ${taito_setv:?}
    # TODO add users to docker group to avoid sudo?
    docker save "$1" | \
      ssh ${opts} -C "${taito_ssh_user:?}@${taito_host:?}" sudo docker load
  )
fi

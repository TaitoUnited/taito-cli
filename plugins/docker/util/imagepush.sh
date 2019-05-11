#!/bin/bash

if [[ ${taito_container_registry_provider:-} != "ssh" ]]; then
  (
    ${taito_setv:?}
    docker push "$1"
  )
else
  (
    ${taito_setv:?}
    docker save "$1" | \
      ssh -C "${taito_ssh_user:-taito}@${taito_container_registry:?}" docker load
  )
fi

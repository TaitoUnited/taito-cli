#!/bin/bash

if [[ ${taito_container_registry_provider:-} != "ssh" ]]; then
  (
    ${taito_setv:?}
    docker pull "$1"
  )
else
  echo "TODO: docker pull for ssh registry"
fi

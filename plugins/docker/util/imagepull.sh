#!/bin/bash

if [[ ${taito_container_registry_provider:-} != "local" ]]; then
  (
    ${taito_setv:?}
    docker pull "$1"
  )
fi

# TODO: docker pull for host registry provider?

#!/bin/bash -e

if [[ ${docker_compose_skip_restart:-} != "true" ]]; then
  echo
  echo "You may need to restart at least some of the containers to deploy the"
  echo "new secrets. For example:"
  echo
  echo "$ taito restart:server"
  echo "$ taito restart"
  echo
fi

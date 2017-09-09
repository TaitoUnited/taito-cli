#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

command="${1}"

if [[ "${command}" == "--clean" ]]; then
  "${taito_plugin_path}/util/clean.sh" && \
  "${taito_cli_path}/util/execute-on-host.sh" \
    "docker-compose up --force-recreate --build" 15
else
  "${taito_cli_path}/util/execute-on-host.sh" "docker-compose up" 15
fi

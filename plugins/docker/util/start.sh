#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

command="${1}"

if [[ "${command}" == "--clean" ]]; then
  "${taito_plugin_path}/util/clean.sh" && \
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker-compose up --force-recreate --build"
else
  "${taito_cli_path}/util/execute-on-host-fg.sh" "docker-compose up"
fi

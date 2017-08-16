#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

command="${1}"

if [[ "${command}" == "--clean" ]]; then
  if ! "${taito_plugin_path}/util/clean.sh"; then
    exit 1
  fi
  if ! "${taito_cli_path}/util/execute-on-host.sh" "docker-compose up --build" 15; then
    exit 1
  fi
else
  if ! "${taito_cli_path}/util/execute-on-host.sh" "docker-compose up" 15; then
    exit 1
  fi
fi

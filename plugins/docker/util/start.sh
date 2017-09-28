#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

switches=" ${*} "

setenv=""
if [[ "${switches}" == *"--prod"* ]]; then
  setenv="dockerfile=Dockerfile.build "
fi

if [[ "${switches}" == *"--clean"* ]]; then
  "${taito_plugin_path}/util/clean.sh" && \
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "${setenv}docker-compose up --force-recreate --build"
else
  "${taito_cli_path}/util/execute-on-host-fg.sh" "${setenv}docker-compose up"
fi

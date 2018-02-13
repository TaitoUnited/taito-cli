#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"

switches=" ${*} "

if [[ "${switches}" == *"--clean"* ]]; then
  echo "Deleting all data from database ${postgres_database}"
  "${taito_plugin_path}/util/clean.sh"
fi && \

echo "Deploying changes to database ${taito_env}" && \
"${taito_plugin_path}/util/deploy-changes.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

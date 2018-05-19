#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"

switches=" ${*} "

if [[ "${switches}" == *"--clean"* ]]; then
  echo "Deleting all data from database ${database_name}"
  echo "TODO implement"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

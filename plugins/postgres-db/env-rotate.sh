#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

. "${taito_plugin_path}/util/postgres-username-password.sh"

if [[ -n ${database_build_password:-} ]] && [[ -n ${database_app_password:-} ]]; then
  echo "Creating users / altering passwords for ${taito_env}"

  export database_username=postgres
  "${taito_plugin_path}/util/create-users.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

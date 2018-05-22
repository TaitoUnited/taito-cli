#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

echo "TODO execute for all postgres databases"
if [[ "${database_type:-}" == "postgres" ]] || [[ -z "${database_type}" ]]; then
  . "${taito_plugin_path}/util/postgres-username-password.sh"

  if [[ -n ${database_build_password:-} ]] && \
     [[ -n ${database_app_password:-} ]]; then
    echo "Creating users / altering passwords for ${taito_env}"

    export database_username=postgres
    "${taito_plugin_path}/util/create-users.sh"
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

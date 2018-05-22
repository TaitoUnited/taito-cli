#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

(
  databases=("${taito_target:-$taito_databases}")
  for database in ${databases[@]}
  do
    export taito_target="${database}"
    . "${taito_util_path}/read-database-config.sh" "${database}" && \

    if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
      . "${taito_plugin_path}/util/postgres-username-password.sh"

      if [[ -n ${database_build_password:-} ]] && \
         [[ -n ${database_app_password:-} ]]; then
        echo "Creating users / altering passwords for ${taito_env}"

        export database_username=postgres
        "${taito_plugin_path}/util/create-users.sh"
      fi
    fi
  done
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

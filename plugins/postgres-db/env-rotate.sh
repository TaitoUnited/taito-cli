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
      . "${taito_plugin_path}/util/postgres-username-password.sh" && \

      if [[ -n ${database_build_password:-} ]] && \
         [[ -n ${database_app_password:-} ]] && ( \
           [[ ${database_build_password_changed:-} ]] || \
           [[ ${database_app_password_changed:-} ]]
         ); then
        if "${taito_cli_path}/util/confirm-execution.sh" "postgres" "" "Configure new database passwords to postgres"
        then
          echo "Creating users / altering passwords for ${taito_env}"
          echo
          echo "NOTE: YOU CAN IGNORE THE 'role already exists' ERROR MESSAGES"
          echo

          export database_username=postgres
          "${taito_plugin_path}/util/create-users.sh" && \

          echo && \
          echo "NOTE: YOU CAN IGNORE THE 'role/user already exists' ERROR MESSAGES"
        fi
      fi
    fi
  done
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

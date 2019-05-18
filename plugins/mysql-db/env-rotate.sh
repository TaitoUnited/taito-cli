#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

if [[ "${taito_env}" != "local" ]]; then
  (
    all=$("$taito_util_path/get-targets-by-type.sh" database)
    databases=("${taito_target:-$all}")
    for database in ${databases[@]}
    do
      export taito_target="${database}"
      . "${taito_util_path}/read-database-config.sh" "${database}" && \

      if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
        . "${taito_util_path}/database-username-password.sh" && \

        if [[ -n ${database_build_password:-} ]] && \
           [[ -n ${database_app_password:-} ]] && ( \
             [[ ${database_build_password_changed:-} ]] || \
             [[ ${database_app_password_changed:-} ]]
           ); then
          if "${taito_cli_path}/util/confirm-execution.sh" "mysql" "" \
            "Set new passwords for mysql database ${database_name:-}"
          then
            export database_username=${database_master_username:-root}
            echo "HINT: You can get the ${database_username} user password from:"
            echo "${database_master_password_hint:-}"
            . "${taito_plugin_path}/util/ask-password.sh" && \
            "${taito_plugin_path}/util/create-users.sh" && \
            echo "Altered database user passwords for database ${database_name:-}"
          fi
        fi
      fi
    done
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

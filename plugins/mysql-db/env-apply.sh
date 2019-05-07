#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

name=${1}

if [[ "${taito_env}" != "local" ]]; then
  (
    all=$("$taito_util_path/get-targets-by-type.sh" database)
    databases=("${taito_target:-$all}")
    for database in ${databases[@]}
    do
      export taito_target="${database}"
      . "${taito_util_path}/read-database-config.sh" "${database}" && \

      if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
        if "${taito_cli_path}/util/confirm-execution.sh" "mysql" "${name}" \
          "Create mysql database ${database_name}"
        then
          # Create a subshell to contain password
          (
            export database_username=${database_master_username:-root}
            echo "HINT: You can get the ${database_username} user password from:"
            echo "${database_master_password_hint:-}"
            . "${taito_plugin_path}/util/ask-password.sh" && \
            "${taito_plugin_path}/util/create-users.sh" && \
            "${taito_plugin_path}/util/create-database.sh" && \
            echo "Created database ${database_name:-}"
          )
        fi
      fi
    done
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

(
  databases=("${taito_target:-$taito_databases}")
  for database in ${databases[@]}
  do
    export taito_target="${database}"
    . "${taito_util_path}/read-database-config.sh" "${database}" && \

    if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
      if "${taito_cli_path}/util/confirm-execution.sh" "mysql" "${name}" \
        "Delete mysql database ${database_name}"
      then
        # Create a subshell to contain password
        (
          export database_username=root
          . "${taito_plugin_path}/util/ask-password.sh" && \
          "${taito_plugin_path}/util/drop-database.sh" && \
          "${taito_plugin_path}/util/drop-users.sh"
        )
      fi
    fi
  done
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

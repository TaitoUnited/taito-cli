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

    if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
      if "${taito_cli_path}/util/confirm-execution.sh" "${database_name}" "${name}" \
        "Recreate postgres database ${database_name}"
      then
        # Create a subshell to contain password
        (
          export database_username=postgres
          . "${taito_plugin_path}/util/ask-password.sh" && \
          "${taito_plugin_path}/util/drop-database.sh" && \
          "${taito_plugin_path}/util/create-database.sh"
        )
      fi
    fi
  done
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if "${taito_cli_path}/util/confirm-execution.sh" "postgres" "${name}"; then
  (
    databases=("${taito_target:-$taito_databases}")
    for database in ${databases[@]}
    do
      export taito_target="${database}"
      . "${taito_util_path}/read-database-config.sh" "${database}" && \

      if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
        # Create a subshell to contain password
        (
          echo "Dropping database and users"
          export database_username=postgres
          . "${taito_plugin_path}/util/ask-password.sh" && \
          "${taito_plugin_path}/util/drop-database.sh" && \
          "${taito_plugin_path}/util/drop-users.sh"
        )
      fi
    done
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

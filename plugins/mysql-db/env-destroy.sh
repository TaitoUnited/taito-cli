#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo "TODO execute for all mysql databases"
if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
  # Create a subshell to contain password
  (
    echo "Dropping database and users"
    export database_username=mysql
    echo "TODO implement"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

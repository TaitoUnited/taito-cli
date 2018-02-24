#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# Create a subshell to contain password
(
  echo "Dropping database and users"
  export database_username=mysql
  echo "TODO implement"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

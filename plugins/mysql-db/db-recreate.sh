#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# Create a subshell to contain password
(
  export database_username=root
  echo "TODO implement"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

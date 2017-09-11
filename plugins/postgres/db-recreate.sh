#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# Create a subshell to contain password
(
  echo
  echo "### postgres - db-recreate: Recreating database ###"
  export postgres_username=postgres
  . "${taito_plugin_path}/util/ask-password.sh"
  "${taito_plugin_path}/util/delete-database.sh"
  "${taito_plugin_path}/util/create-database.sh"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

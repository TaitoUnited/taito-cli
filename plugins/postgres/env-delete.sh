#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# Create a subshell to contain password
(
  echo
  echo "### postgres - env-delete: Dropping database and users ###"
  export postgres_username=postgres
  . "${taito_plugin_path}/util/ask-password.sh"
  "${taito_plugin_path}/util/drop-database.sh"
  "${taito_plugin_path}/util/drop-users.sh"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

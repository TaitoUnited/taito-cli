#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### postgres - rotate: Creating users / altering passwords for ${taito_env} ###"
echo

export postgres_username=postgres
if ! "${taito_plugin_path}/util/create-users.sh"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

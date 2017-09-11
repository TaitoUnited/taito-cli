#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### postgres - env-rotate: Creating users / altering passwords for \
${taito_env} ###"

export postgres_username=postgres
"${taito_plugin_path}/util/create-users.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

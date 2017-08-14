#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### postgres - init: Deploying changes to database ${taito_env} ###"
echo

if ! "${taito_plugin_path}/util/deploy-changes.sh"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

echo
echo "### postgres - db-deploy: Deploying database changes to ${taito_env} ###"
echo

if ! "${taito_plugin_path}/util/deploy-changes.sh" "${@}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

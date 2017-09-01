#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - start: Starting application on ${taito_env} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! "${taito_plugin_path}/util/deploy.sh"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

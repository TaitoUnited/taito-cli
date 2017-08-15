#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - env-cert: Adding certificate ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! echo "kubectl: TODO implement"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_customer:?}"

echo
echo "### kubectl - canary: Releasing canary release ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! echo "kubectl: TODO not implemented"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

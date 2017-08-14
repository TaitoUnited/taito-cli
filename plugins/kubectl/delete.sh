#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - delete: Deleting secrets from Kubernetes ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! "${taito_plugin_path}/util/delete-secrets.sh"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - create: Saving new secrets to Kubernetes ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

# Make sure that namespace exists
kubectl create namespace "${taito_customer}-${taito_env}" &> /dev/null

if ! "${taito_plugin_path}/util/save-secrets.sh"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

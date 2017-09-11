#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - env-create: Saving new secrets to Kubernetes ###"

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

# Make sure that namespace exists
kubectl create namespace "${taito_customer}-${taito_env}" &> /dev/null

"${taito_plugin_path}/util/save-secrets.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

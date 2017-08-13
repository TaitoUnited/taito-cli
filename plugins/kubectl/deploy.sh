#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - deploy: Deploying application to Kubernetes ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! "${taito_plugin_path}/util/deploy.sh" "${@}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

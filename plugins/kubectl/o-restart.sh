#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - restart: Restarting all pods in ${taito_env} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! kubectl delete pods --all; then
  exit 1
fi
echo
echo "kubectl: TODO rolling restart instead of kill"
echo

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

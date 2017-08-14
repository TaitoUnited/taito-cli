#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

pod="${1}"

echo
echo "### kubectl - kill: Killing pod ${pod} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! kubectl delete pod "${pod}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

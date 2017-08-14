#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

echo
echo "### kubectl - stop: Stopping application on ${taito_env} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

echo "TODO scale replicas to 0 instead of deleting"
if ! helm delete --purge "${taito_project_env}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

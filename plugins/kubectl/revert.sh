#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

echo
echo "### kubectl - revert: Reverting application in ${taito_env} ###"
echo

revision="${1}"
if [[ "${revision}" == "" ]]; then
  revision=0
fi

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

if ! helm rollback "${taito_project_env}" "${revision}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

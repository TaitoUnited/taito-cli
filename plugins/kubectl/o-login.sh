#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - login: Logging in to ${pod} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

"${taito_plugin_path}/util/exec.sh" "${1}" "${2:--}" /bin/bash
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

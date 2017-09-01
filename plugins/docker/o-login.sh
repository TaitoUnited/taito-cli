#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

pod="${1}"

echo
echo "### docker - login: Loggin in to ${pod} ###"
echo

"${taito_plugin_path}/util/exec.sh" "${1}" "${2:--}" /bin/bash
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

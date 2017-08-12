#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# command="${1}"

echo
echo "### docker - restart: Restarting ###"
echo

if ! "${taito_cli_path}/util/execute-on-host.sh" "docker-compose down"; then
  exit 1
fi
if ! echo "${taito_plugin_path}/util/start.sh" "${@}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

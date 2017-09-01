#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker - start: Showing status ###"
echo

if ! "${taito_cli_path}/util/execute-on-host.sh" "docker-compose ps"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

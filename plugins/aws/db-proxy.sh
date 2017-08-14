#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### aws - db-proxy: Starting db proxy ###"
echo

echo "host=0.0.0.0, port=TODO"
echo
echo "Connect using your personal user account or"
echo "${postgres_database} as username"

if ! echo "TODO not implemented"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

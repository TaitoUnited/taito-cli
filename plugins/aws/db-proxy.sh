#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### aws - db-proxy: Starting db proxy ###"

echo "host=0.0.0.0, port=TODO"
echo "Connect using your personal user account or"
echo "${postgres_database} as username"

echo "TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### serverless - restart: Restarting ###"
echo

exit 1

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

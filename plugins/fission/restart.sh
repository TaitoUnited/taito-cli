#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### fission - restart: Restarting ###"
echo
echo TODO

exit 1

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

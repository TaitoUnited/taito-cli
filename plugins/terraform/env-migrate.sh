#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### terraform - env-migrate: TODO ###"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

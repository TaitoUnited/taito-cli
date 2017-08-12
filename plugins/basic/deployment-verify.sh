#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_app_url:?}"

echo
echo "### basic - deployment-verify: Verifying deployment ###"
echo

echo "TODO implement"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

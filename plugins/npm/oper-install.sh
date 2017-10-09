#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### npm - oper-install: Installing ###"

npm install && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

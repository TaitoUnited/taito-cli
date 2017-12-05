#!/bin/bash

: "${taito_cli_path:?}"

echo "TODO implement: build, push and deploy single container"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

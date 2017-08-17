#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### example - hello: Running hello world! ###"
echo
echo "Hello world!"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

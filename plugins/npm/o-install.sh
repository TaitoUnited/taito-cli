#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### npm - install: Installing ###"
echo

if ! npm install; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

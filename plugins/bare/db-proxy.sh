#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### bare - db-proxy: Starting db proxy ###"
echo

# TODO open db proxy connection to machine?

if ! echo "TODO not implemented"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

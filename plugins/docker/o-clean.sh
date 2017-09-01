#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### docker - clean: Cleaning ###"
echo

if ! "${taito_plugin_path}/util/clean.sh" "${@}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

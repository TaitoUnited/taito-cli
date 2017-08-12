#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### basic - help: Showing help files ###"
echo

if ! "${taito_plugin_path}/util/show_file.sh" help.txt cat; then
  exit 1
fi
echo

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

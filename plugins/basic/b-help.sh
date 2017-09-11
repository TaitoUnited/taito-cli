#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### basic - b-help: Showing help files ###"

"${taito_plugin_path}/util/show_file.sh" help.txt cat && \
echo && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

filter=${1}

echo
echo "### basic - --help: Showing help files ###"
echo

"${taito_plugin_path}/util/show_file.sh" help.txt cat "${filter}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

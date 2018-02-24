#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo "Deleting all node_modules directories recursively"
echo "NOTE: Remember to run 'taito install' after clean"

"${taito_plugin_path}/util/clean.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

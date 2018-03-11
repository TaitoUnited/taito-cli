#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo "Dumping data to file ${1}. Please wait..."

"${taito_plugin_path}/util/mysqldump.sh" > "${1}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

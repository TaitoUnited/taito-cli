#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${database_name:?}"

dump_file="${1:?}"

echo "Dumping database ${database_name} to file ${dump_file}. Please wait..."
"${taito_plugin_path}/util/mysqldump.sh" > "${dump_file}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

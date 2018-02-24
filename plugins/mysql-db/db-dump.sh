#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

username="${1}"

echo "host: ${database_host} port:${database_port}"
echo "TODO implement"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

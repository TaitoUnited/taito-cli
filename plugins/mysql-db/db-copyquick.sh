#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

dest="${taito_env}"
source="${1:?Source not given}"
username="${2}"

echo "TODO implement"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
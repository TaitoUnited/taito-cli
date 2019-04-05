#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo "Cleaning up secrets from disk"
"${taito_plugin_path:?}/util/file-delete.sh"

# Call next command on command chain. Exported variables:
"${taito_cli_path}/util/call-next.sh" "${@}"

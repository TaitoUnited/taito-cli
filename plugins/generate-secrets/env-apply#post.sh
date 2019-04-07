#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name="${1}"

echo "Cleaning up temporary secret files from disk"
"${taito_plugin_path:?}/util/file-delete.sh"

# Call next command on command chain. Exported variables:
"${taito_util_path}/call-next.sh" "${@}"

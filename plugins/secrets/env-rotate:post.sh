#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path:?}/util/confirm-file-delete.sh"

# Call next command on command chain. Exported variables:
"${taito_cli_path}/util/call-next.sh" "${@}"

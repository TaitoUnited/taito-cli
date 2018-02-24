#!/bin/bash
: "${taito_cli_path:?}"

echo "TODO implement: install/upgrade helm apps defined in taito-config.sh"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"

echo "TODO create build trigger"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

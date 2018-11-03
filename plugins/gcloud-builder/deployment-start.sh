#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"

echo "TODO implement"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_env:?}"
: "${taito_vc_repository:?}"

echo "TODO implement"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_env:?}"

"${taito_util_path}/local-ci.sh" "$taito_env"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

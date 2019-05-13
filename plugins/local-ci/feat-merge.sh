#!/bin/bash -e
: "${taito_util_path:?}"

dest="${taito_branch:-dev}"
"${taito_util_path}/local-ci.sh" "$dest"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

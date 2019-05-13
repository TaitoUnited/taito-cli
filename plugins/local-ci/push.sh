#!/bin/bash -e
: "${taito_util_path:?}"

branch=$(git rev-parse --abbrev-ref HEAD)
"${taito_util_path}/local-ci.sh" "$branch"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

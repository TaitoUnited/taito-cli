#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

branch=$(git rev-parse --abbrev-ref HEAD)
"${taito_plugin_path}/util/ci.sh" "$branch"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

dest="${taito_branch:-dev}"
"${taito_plugin_path}/util/ci.sh" "$dest"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

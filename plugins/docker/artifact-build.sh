#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/util/build.sh" "${@}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

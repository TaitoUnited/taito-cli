#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/util/storage-copy-between.sh" "${@}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

echo "TODO confirm and delete all files from destination bucket" && \
"${taito_plugin_path}/util/storage-copy-to.sh" "${@}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash

: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name="${1}"

"${taito_util_path}/browser-fg.sh" "TODO" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
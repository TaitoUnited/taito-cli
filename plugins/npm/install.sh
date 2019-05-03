#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/install.sh" "${@}" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

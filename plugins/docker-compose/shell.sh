#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"

"${taito_plugin_path}/util/exec.sh" "/bin/sh" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

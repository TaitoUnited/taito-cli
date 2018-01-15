#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

pod="${1:?Pod name not given}"

"${taito_plugin_path}/util/exec.sh" "${pod}" "${2:--}" /bin/sh && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

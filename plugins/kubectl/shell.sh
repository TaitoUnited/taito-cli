#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

"${taito_plugin_path}/util/exec.sh" "/bin/sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

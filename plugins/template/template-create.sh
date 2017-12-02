#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

export template="${1:?Template not given}"
export template_name="${template}"

"${taito_plugin_path}/util/init.sh" "create" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name="${1}"

"${taito_cli_path}/util/browser-fg.sh" "TODO" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

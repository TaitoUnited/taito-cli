#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

"${taito_plugin_path}/util/sqitch.sh" add "${@:1}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
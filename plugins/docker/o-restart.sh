#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### docker - o-restart: Restarting ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" "docker-compose down" && \
echo "${taito_plugin_path}/util/start.sh" "${@}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

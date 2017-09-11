#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker - o-stop: Stopping ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" "docker-compose down" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

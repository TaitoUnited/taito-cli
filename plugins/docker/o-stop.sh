#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker - o-stop: Stopping ###"
echo

"${taito_cli_path}/util/execute-on-host.sh" "docker-compose down" 6 && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

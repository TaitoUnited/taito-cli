#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### docker - o-status: Showing status ###"
echo

"${taito_cli_path}/util/execute-on-host-fg.sh" "docker-compose ps" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

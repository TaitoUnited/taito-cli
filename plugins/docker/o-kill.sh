#!/bin/bash

: "${taito_cli_path:?}"

pod="${1:?Pod name not given}"

echo
echo "### docker - o-kill: Killing in the name of ${pod} ###"
echo

"${taito_cli_path}/util/execute-on-host-fg.sh" "docker kill ${pod}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

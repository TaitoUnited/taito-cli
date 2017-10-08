#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project:?}"

pod="${1:?Pod name not given}"

if [[ ${pod} != *"-"* ]]; then
  pod="${taito_project}-${pod}"
fi

echo
echo "### docker - o-kill: Killing in the name of ${pod} ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" "docker kill ${pod}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

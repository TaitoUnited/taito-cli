#!/bin/bash

: "${taito_cli_path:?}"

pod="${1:?Pod name not given}"

echo
echo "### docker - o-logs: Showing some logs ###"
echo

if [[ -z "${pod}" ]]; then
  echo
  echo "Please give pod name as argument:"
  echo
  exit 1
else
  "${taito_cli_path}/util/execute-on-host-fg.sh" "docker logs --tail 400 ${pod}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

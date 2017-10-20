#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_project:?}"

pod="${1:?Pod name not given}"

if [[ ${pod} != *"-"* ]]; then
  pod="${taito_project}-${pod}"
fi

echo
echo "### docker - oper-logs: Showing some logs ###"

if [[ -z "${pod}" ]]; then
  echo "Please give pod name as argument:"
  exit 1
else
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker logs -f --tail 400 ${pod}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

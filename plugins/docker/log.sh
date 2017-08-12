#!/bin/bash

: "${taito_cli_path:?}"

pod="${1}"

echo
echo "### docker - log: Showing some logs ###"
echo

if [[ -z "${pod}" ]]; then
  echo
  echo "Please give pod name as argument:"
  echo
else
  if ! "${taito_cli_path}/util/execute-on-host.sh" "docker logs --tail 400 ${pod}"; then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

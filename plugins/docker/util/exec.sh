#!/bin/bash

: "${taito_cli_path:?}"

pod="${1}"
command=("${@:3}")

if [[ -z "${pod}" ]]; then
  echo
  echo "Please give pod name as argument:"
  echo
else
  if ! "${taito_cli_path}/util/execute-on-host.sh" "docker exec -it ${pod} ${command[@]}"; then
    exit 1
  fi
fi

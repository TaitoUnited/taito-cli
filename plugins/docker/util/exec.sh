#!/bin/bash

: "${taito_cli_path:?}"

pod="${1}"
command=("${@:3}")

if [[ -z "${pod}" ]]; then
  echo
  echo "Please give pod name as argument:"
  echo
  exit 1
else
  "${taito_cli_path}/util/execute-on-host-fg.sh" \
    "docker exec -it ${pod} ${command[@]}"
fi

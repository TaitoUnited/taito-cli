#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

echo && \
echo "### docker - ci-wait: Waiting for docker to start..." && \
counter=1 && \
up="" && \
while [[ ${counter} -le 120 ]] && [[ ! ${up} ]]
do
  if [[ ${counter} -gt 50 ]]; then
    echo "Waiting for docker to start ${counter}..."
    docker-compose ps
  fi
  up=$(docker-compose ps | grep " Up " | grep -E "\-server|\-client")
  sleep 5
  ((counter++))
done && \
sleep 5 && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

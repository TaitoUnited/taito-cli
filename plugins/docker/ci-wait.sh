#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

echo "Waiting for docker to start..." && \
counter=1 && \
up="" && \
while [[ $counter -le 10 ]] && [[ ! ${up} ]]
do
  echo "Waiting ${counter}..."
  docker-compose ps
  up=$(docker-compose ps | grep " Up " | grep -E "\-server|\-client")
  echo
  sleep 5
  ((counter++))
done && \
sleep 5 && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

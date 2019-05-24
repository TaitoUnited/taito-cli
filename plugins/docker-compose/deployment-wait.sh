#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"
exit $?

# TODO implement
echo && \
echo "Waiting for docker to start." && \
counter=1 && \
up="" && \
while [[ ${counter} -le 120 ]] && [[ ! ${up} ]]
do
  if [[ ${counter} -gt 50 ]]; then
    echo "Waiting for docker to start ${counter}."
    docker-compose ps
  fi
  up=$(docker-compose ps | grep " Up " | grep -E "\-server|\-client")
  sleep "${ci_wait_test_sleep:-5}"
  ((counter++))
done && \
sleep "${ci_wait_test_sleep:-5}"

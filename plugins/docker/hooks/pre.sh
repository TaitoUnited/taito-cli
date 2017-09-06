#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

if [[ "${taito_command}" = "ci-test-api" ]] ||
   [[ "${taito_command}" = "ci-test-e2e" ]]; then
   echo
   echo "### docker - pre: Starting ###"
   echo

   file="${taito_project_path}/docker-compose.yaml"
   if [[ -f "${taito_project_path}/docker-test.yaml" ]]; then
     file="${taito_project_path}/docker-test.yaml"
   fi

   "${taito_cli_path}/util/execute-on-host.sh" \
     "docker-compose up --build -f ${file}" && \

   echo "Waiting for docker to start..." && \
   echo "TODO check status instead of hardcoded long wait." && \
   sleep 20
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

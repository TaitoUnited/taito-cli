#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

if ([[ "${taito_mode:-}" != "ci" ]] \
     || [[ "${ci_test_env:-}" == "true" ]]) && \
   ([[ "${taito_command}" == "ci-test-api" ]] \
     || [[ "${taito_command}" == "ci-test-e2e" ]]); then
   echo
   echo "### docker - post: Stopping ###"
   echo

   file="${taito_project_path}/docker-compose.yaml"
   if [[ -f "${taito_project_path}/docker-test.yaml" ]]; then
     file="${taito_project_path}/docker-test.yaml"
   fi

   "${taito_cli_path}/util/execute-on-host.sh" \
     "docker-compose down -f ${file}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_command:?}"

if ([[ "${taito_command}" == "ci-test-api" ]] || \
      [[ "${taito_command}" == "ci-test-e2e" ]]) && \
   ([[ "${taito_mode:-}" != "ci" ]] || \
      [[ "${ci_test_env:-}" == "true" ]]) && \
   [[ ! -f ./taitoflag_image_pulled ]]; then
   echo
   echo "### docker - post: Stopping docker-compose used for ci-testing ###"
   echo

   file="${taito_project_path}/docker-compose.yaml"
   if [[ -f "${taito_project_path}/docker-test.yaml" ]]; then
     file="${taito_project_path}/docker-test.yaml"
   fi

   "${taito_cli_path}/util/execute-on-host.sh" \
     "docker-compose -f ${file} down"

fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

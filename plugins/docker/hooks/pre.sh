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
   echo "### docker - pre: Starting docker-compose for ci-testing purposes ###"
   echo

   # TODO how to avoid running docker-in-docker on google container
   # environment?
   # https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
   file="${taito_project_path}/docker-compose.yaml"
   if [[ -f "${taito_project_path}/docker-test.yaml" ]]; then
     file="${taito_project_path}/docker-test.yaml"
   fi

   # TODO use minikube instead for CI testing
   if [[ "${taito_mode:-}" == "ci" ]]; then \
     # TODO --no-build
     "${taito_cli_path}/util/execute-on-host.sh" \
       "docker-compose --project-name test -f ${file} up"
   else
     "${taito_cli_path}/util/execute-on-host.sh" \
       "docker-compose --project-name test -f ${file} up"
   fi

   echo "Waiting for docker to start..." && \
   counter=1
   while [[ $counter -le 120 ]] || [[ ! ${up} ]]
   do
     sleep 5
     echo "Waiting ${counter}..."
     up=$(docker-compose ps | grep " Up ")
     ((counter++))
   done

   echo "TODO check status instead of hardcoded long wait." && \
   sleep 300
   # TODO test with: docker-compose ps --> grep Up and then sleep for a while
fi &&

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

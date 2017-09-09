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
   if [[ "${taito_mode:-}" == "ci" ]]; then
     # TODO enable --no-build
     "${taito_cli_path}/util/execute-on-host.sh" \
       "docker-compose --project-name workspace -f ${file} up"
   else
     "${taito_cli_path}/util/execute-on-host.sh" \
       "docker-compose -f ${file} up"
   fi

   echo "Waiting for docker to start..." && \
   counter=1 && \
   up="" && \
   while [[ $counter -le 10 ]] && [[ ! ${up} ]]
   do
     echo "Waiting ${counter}..."
     docker-compose ps
     up=$(docker-compose --project-name workspace ps | grep " Up " | grep -E "\-server|\-client")
     echo
     sleep 5
     ((counter++))
   done
   # TODO remove
   sleep 30
fi &&

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

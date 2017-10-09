#!/bin/bash

: "${taito_env:?}"
: "${taito_command:?}"
: "${taito_plugin_path:?}"

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_command_chain:-} == *"kubectl/"* ]]; then
  echo
  echo "### bare - pre: Getting credentials for kubernetes ###"
  echo "TODO implement"
fi && \

if [[ ${taito_env} != "local" ]] && \
   [[ ${taito_command_chain:-} == *"postgres/"* ]] && \
   [[ ${taito_command} != "ci-test-"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo
    echo "### bare - pre: Starting db proxy ###"
    echo "TODO implement"
  else
    echo
    echo "### bare - pre: Not Starting db proxy. It is already running ###"
  fi
fi

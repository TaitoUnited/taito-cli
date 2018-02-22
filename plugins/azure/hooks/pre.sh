#!/bin/bash

if [[ ${taito_command_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo "### azure/pre: Starting db proxy"
    echo "TODO implement"
  else
    echo "### azure/pre: Not Starting db proxy. It is already running."
  fi
fi && \

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_command_chain:-} == *"kubectl/"* ]]; then
  echo "### azure/pre: Getting credentials for kubernetes"
  echo "TODO implement"
fi

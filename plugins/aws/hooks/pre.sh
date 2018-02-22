#!/bin/bash

if [[ ${taito_command_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running:-}" == "" ]]; then
    echo "### aws/pre: Starting db proxy"
    echo "TODO implement"
  else
    echo "### aws/pre: Not Starting db proxy. It is already running."
  fi
fi && \

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_command_chain:-} == *"kubectl/"* ]]; then
  echo "### aws/pre: Getting credentials for kubernetes"
  echo "TODO implement"
fi

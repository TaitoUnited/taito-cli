#!/bin/bash

: "${taito_env:?}"
: "${taito_command:?}"
: "${taito_plugin_path:?}"

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_command_chain:-} == *"kubectl/"* ]]; then
  echo "### gcloud/pre: Getting credentials for kubernetes"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi && \

if [[ ${taito_env} != "local" ]] && \
   [[ ${taito_command_chain:-} == *"postgres/"* ]] && \
   [[ ${taito_command} != "ci-test-"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo "### gcloud/pre: Starting db proxy"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo "### gcloud/pre: Not Starting db proxy. It is already running."
  fi
fi

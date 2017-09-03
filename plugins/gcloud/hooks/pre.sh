#!/bin/bash

: "${taito_env:?}"
: "${taito_command:?}"
: "${gcloud_project:?}"
: "${gcloud_zone:?}"
: "${postgres_name:?}"
: "${gcloud_sql_proxy_port:?}"

if [[ "${taito_mode}" == "ci" ]] && [[ ${taito_command_chain} == *"kubectl/"* ]]; then
  echo
  echo "### gcloud - pre: Getting credentials for kubernetes ###"
  echo
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi && \

if [[ ${taito_env} != "local" ]] && [[ ${taito_command_chain} == *"postgres/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo
    echo "### gcloud - pre: Starting db proxy ###"
    echo
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo
    echo "### gcloud - pre: Not Starting db proxy. It is already running ###"
    echo
  fi
fi

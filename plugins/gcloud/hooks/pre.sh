#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo "### gcloud/pre: Starting db proxy"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo "### gcloud/pre: Not Starting db proxy. It is already running."
  fi
fi && \

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]]; then
  echo "### gcloud/pre: Getting credentials for kubernetes"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

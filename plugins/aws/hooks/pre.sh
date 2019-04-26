#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running:-}" == "" ]]; then
    echo
    echo "### aws/pre: Starting db proxy"
    echo "TODO implement"
  else
    echo
    echo "### aws/pre: Not Starting db proxy. It is already running."
  fi
fi && \

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]]; then
  echo
  echo "### aws/pre: Getting credentials for kubernetes"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

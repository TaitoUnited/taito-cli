#!/bin/bash
: "${taito_util_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}azure${H1e}"
  if [[ "${proxy_running}" == "" ]]; then
    echo "Starting db proxy"
    echo "TODO implement"
  else
    echo "Not Starting db proxy. It is already running."
  fi
fi && \

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]]; then
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}azure${H1e}"
  echo "Getting credentials for kubernetes"
  echo "TODO implement"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

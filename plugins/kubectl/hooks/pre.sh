#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_env:?}"

# kubernetes database proxy

if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  proxy_running=$(pgrep "kubectl")
  if [[ "${proxy_running}" == "" ]]; then
    echo
    echo "### kubectl/pre: Starting db proxy"
    "${taito_plugin_path}/util/use-context.sh"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo
    echo "### kubectl/pre: Not Starting db proxy. It is already running."
  fi
fi && \

# kubernetes secrets
# TODO: tighter filter
# NOTE: ci-release is deprecated
secret_filter=
if [[ ${taito_command} == "build-prepare" ]] || \
   [[ ${taito_command} == "build-release" ]] || \
   [[ ${taito_command} == "artifact-prepare" ]] || \
   [[ ${taito_command} == "artifact-release" ]] || \
   [[ ${taito_command} == "ci-release" ]]; then
  secret_filter="git"
elif [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
   [[ ${taito_command} == "test" ]]; then
  secret_filter="db"
fi
if [[ ${secret_filter} ]]; then
  echo
  echo "### kubectl/pre: Getting secrets from Kubernetes"
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh"
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/get-secrets.sh" "true" ${secret_filter}
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

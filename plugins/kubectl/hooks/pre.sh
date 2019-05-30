#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${taito_env:?}"

# kubernetes database proxy

if [[ ${kubernetes_db_proxy_enabled:-} == "true" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  proxy_running=$(pgrep "kubectl")
  echo
  echo -e "${H1s}kubectl${H1e}"
  if [[ "${proxy_running}" == "" ]]; then
    echo "Starting db proxy"
    "${taito_plugin_path}/util/use-context.sh"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo "Not Starting db proxy. It is already running."
  fi
fi && \

# kubernetes secrets
# TODO: tighter filter
# NOTE: ci-release is deprecated
secret_filter=
if [[ $kubectl_secrets_retrieved != true ]]; then
  if [[ ${taito_command} == "build-prepare" ]] || \
     [[ ${taito_command} == "build-release" ]] || \
     [[ ${taito_command} == "artifact-prepare" ]] || \
     [[ ${taito_command} == "artifact-release" ]] || \
     [[ ${taito_command} == "ci-release" ]]; then
    secret_filter="git"
  elif [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
       [[ ${taito_command} == "db-proxy" ]] || \
       [[ ${taito_command} == "test" ]]; then
    secret_filter="db"
  fi
fi

if [[ ${secret_filter} ]]; then
  echo
  echo -e "${H1s}kubectl${H1e}"
  if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
     [[ ${taito_command} == "db-proxy" ]]; then
    echo "Getting secrets from Kubernetes for DB access"
  else
    echo "Getting secrets from Kubernetes for making a release"
  fi
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh"
  # shellcheck disable=SC1090
  . "${taito_plugin_path}/util/get-secrets.sh" "true" ${secret_filter}
  export kubectl_secrets_retrieved=true
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

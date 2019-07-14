#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

# Automatic authentication on 'env apply'
if [[ $taito_command == "env-apply" ]] && [[ "${taito_mode:-}" != "ci" ]]; then
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}gcp${H1e}"
  echo "Authenticating"
  "${taito_plugin_path}/util/auth.sh"
fi && \

if [[ $GOOGLE_APPLICATION_CREDENTIALS ]]; then
  account=$(gcloud config get-value account 2> /dev/null)
  if [[ ! $account ]]; then
    echo
    echo -e "${taito_command_context_prefix:-}${H1s}gcp${H1e}"
    echo "Authenticating with key $GOOGLE_APPLICATION_CREDENTIALS"
    gcloud auth activate-service-account \
      "--key-file=$GOOGLE_APPLICATION_CREDENTIALS" # --project=...
  fi
fi && \

# Kubernetes credentials for ci
if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${kubernetes_name:-} ]] && \
   [[ ! -d "${HOME}/.kube" ]] && \
   [[ ! -d "/root/.kube" ]]; then
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}gcp${H1e}"
  echo "Getting GCP credentials for Kubernetes access"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi && \

# Database proxy
if [[ ${taito_provider:-} == "gcp" ]] && \
   [[ ${gcp_db_proxy_enabled:-} != "false" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  echo
  echo -e "${taito_command_context_prefix:-}${H1s}gcp${H1e}"
  if [[ "${proxy_running}" == "" ]]; then
    echo "Starting db proxy"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo "Not Starting db proxy. It is already running."
  fi
fi && \

# Create new Google project on env apply
if [[ $taito_command == "env-apply" ]] && \
   [[ ${taito_commands_only_chain:-} == *"terraform/"* ]]; then
  if [[ $taito_provider == "gcp" ]] && \
     [[ ${taito_provider_org_id:-} ]] && \
     [[ ${taito_zone:-} ]]; then
    "${taito_plugin_path}/util/ensure-project-exists.sh" \
      "${taito_zone}" "${taito_provider_org_id}"
  fi
  if [[ $taito_provider == "gcp" ]] && \
     [[ $taito_provider_org_id ]] && \
     [[ ${taito_resource_namespace_id:-} ]]; then
    "${taito_plugin_path}/util/ensure-project-exists.sh" \
      "${taito_resource_namespace_id:?}" "${taito_provider_org_id}"
  fi
  if [[ ${taito_uptime_provider:-} == "gcp" ]] && \
     [[ ${taito_uptime_provider_org_id:-} ]]; then
    "${taito_plugin_path}/util/ensure-project-exists.sh" \
      "${taito_uptime_namespace_id:-}" "${taito_uptime_provider_org_id}"
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

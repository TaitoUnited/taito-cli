#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"

# Automatic authentication on 'env apply'
if [[ $taito_command == "env-apply" ]] && [[ "${taito_mode:-}" != "ci" ]]; then
  echo
  echo "### gcloud/pre"
  "${taito_plugin_path}/util/auth.sh"
fi && \

# Kubernetes credentials for ci
if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]]; then
  echo
  echo "### gcloud/pre: Getting credentials for kubernetes"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi && \

# Database proxy
if [[ ${taito_provider:-} == "gcloud" ]] && \
   [[ ${gcloud_db_proxy_enabled:-} != "false" ]] && \
   [[ ${taito_requires_database_connection:-} == "true" ]]; then
  proxy_running=$(pgrep "cloud_sql_proxy")
  if [[ "${proxy_running}" == "" ]]; then
    echo
    echo "### gcloud/pre: Starting db proxy"
    "${taito_plugin_path}/util/db-proxy-start.sh" "true"
  else
    echo
    echo "### gcloud/pre: Not Starting db proxy. It is already running."
  fi
fi && \

# Create new Google project on env apply
if [[ $taito_command == "env-apply" ]] && \
   [[ ${taito_commands_only_chain:-} == *"terraform/"* ]]; then
  if [[ $taito_provider == "gcloud" ]] && [[ ${taito_zone:-} ]]; then
    "${taito_plugin_path}/util/ensure-project-exists.sh" \
      "${taito_zone:?}" "${taito_provider_org_id:?}"
  fi
  if [[ $taito_provider == "gcloud" ]] && [[ ${taito_resource_namespace_id:-} ]]; then
    "${taito_plugin_path}/util/ensure-project-exists.sh" \
      "${taito_resource_namespace_id:?}" "${taito_provider_org_id:?}"
  fi
  if [[ ${taito_uptime_provider:-} == "gcloud" ]]; then
    "${taito_plugin_path}/util/ensure-project-exists.sh" \
      "${taito_uptime_namespace_id:-}" "${taito_uptime_provider_org_id:?}"
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

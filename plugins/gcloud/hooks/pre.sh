#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || ( \
    [[ "${taito_command:-}" == "test" ]] &&
    [[ "${taito_plugins:-}" == *"gcloud-ci"* ]] &&
    [[ "${taito_mode:-}" == "ci" ]] \
  ); then
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

if [[ "${taito_mode:-}" == "ci" ]] && \
   [[ ${taito_commands_only_chain:-} == *"kubectl/"* ]]; then
  echo
  echo "### gcloud/pre: Getting credentials for kubernetes"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi && \

if [[ $taito_command == "env-apply" ]] && \
   [[ ${taito_resource_namespace:-} ]] && \
   [[ ${taito_commands_only_chain:-} == *"terraform/"* ]] && \
   ! gcloud projects describe "${taito_resource_namespace}" &> /dev/null; then
  echo
  echo "### gcloud/pre: Creating new Google Cloud project"
  echo
  billing_var="gcloud_billing_account_${taito_organization:-}"
  billing_id=${!billing_var:-$taito_provider_billing_account_id}
  if [[ ! ${billing_id} ]]; then
    echo "Enter billing account id for the new project:"
    read -r billing_id
  else
    echo "Create new Google Cloud project '${taito_resource_namespace:?}' (Y/n)?"
    read -r confirm
    if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
      billing_id=
    fi
  fi

  if [[ ${billing_id} ]] && [[ ${#billing_id} -gt 10 ]]; then
    gcloud projects create "${taito_resource_namespace:?}" \
      "--organization=${taito_provider_org_id:?}" && \
    gcloud beta billing projects link "${taito_resource_namespace:?}" \
      --billing-account "${billing_id}"
  else
    exit 130
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

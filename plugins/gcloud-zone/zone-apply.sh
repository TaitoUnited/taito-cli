#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubectl_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-auth" "${name}" \
    "Authenticate to Kubernetes ${kubectl_name:-}"
  then
      "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh" && \
      "${taito_cli_path}/util/docker-commit.sh"
  fi && \

  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
    "Configure gcloud build notifications"
  then
    "${taito_plugin_path}/util/setup-build-slack-notifications.sh"
  fi

fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

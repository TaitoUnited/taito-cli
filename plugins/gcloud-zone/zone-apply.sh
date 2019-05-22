#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubernetes_name:-}" ]]; then
  if "${taito_util_path}/confirm-execution.sh" "gcloud-auth" "${name}" \
    "Authenticate to Kubernetes ${kubernetes_name:-}"
  then
      "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh" && \
      "${taito_util_path}/docker-commit.sh"
  fi && \

  if "${taito_util_path}/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
    "Configure gcloud build notifications"
  then
    "${taito_plugin_path}/util/setup-build-slack-notifications.sh"
  fi

fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

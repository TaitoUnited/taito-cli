#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubernetes_name:-}" ]]; then
  if "${taito_util_path}/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
    "Destroy gcloud build notifications"
  then
    "${taito_plugin_path}/util/teardown-build-slack-notifications.sh"
  fi
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

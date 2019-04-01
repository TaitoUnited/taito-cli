#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if [[ -n "${kubectl_name:-}" ]]; then
  if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
    "Destroy gcloud build notifications"
  then
    "${taito_plugin_path}/util/teardown-build-slack-notifications.sh"
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

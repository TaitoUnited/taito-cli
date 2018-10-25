#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "gcloud-build-notifications" "${name}" \
  "Configure gcloud build notifications"
then
  "${taito_plugin_path}/util/teardown-build-slack-notifications.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

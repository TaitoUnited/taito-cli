#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_enabled_plugins:?}"

if [[ "${taito_enabled_plugins}" != *"gcloud"* ]]; then
  echo "gcloud plugin not enabled. authenticate using gcloud util."
  taito_plugin_path="${taito_cli_path}/plugins/gcloud" \
    "${taito_cli_path}/plugins/gcloud/util/auth.sh" "${@}"
else
  echo "gcloud plugin enabled. let gcloud plugin authenticate."
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

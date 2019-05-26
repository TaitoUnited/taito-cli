#!/bin/bash -e
: "${taito_zone:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_zone_functions_bucket:?}"
: "${taito_messaging_webhook:?}"
: "${taito_messaging_builds_channel:?}"

function finish {
  rm -rf /tmp/gcp-zone-slack
}

if [[ ${taito_messaging_app:-} == "slack" ]]; then
  trap finish EXIT

  cp -r "${taito_plugin_path}/resources/slack" /tmp/gcp-zone-slack
  cat "/tmp/gcp-zone-slack/config-template.json" | \
    sed "s|\\[SLACK_WEBHOOK_URL\\]|${taito_messaging_webhook}|" | \
    sed "s|\\[BUILDS_CHANNEL\\]|${taito_messaging_builds_channel}|" \
    > "/tmp/gcp-zone-slack/config.json"

  cp "${taito_project_path}/projects.json" "/tmp/gcp-zone-slack"

  echo "Deploying the following settings:"
  cat "/tmp/gcp-zone-slack/config.json"
  cat "/tmp/gcp-zone-slack/projects.json"

  gcloud --project "${taito_zone}" \
    functions deploy cloudBuildSlackNotifications \
    --source "/tmp/gcp-zone-slack" \
    --stage-bucket "${taito_zone_functions_bucket}" \
    --trigger-topic cloud-builds \
    --entry-point subscribe \
    --region "europe-west1"
fi

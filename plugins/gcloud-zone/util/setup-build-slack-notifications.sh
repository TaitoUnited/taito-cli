#!/bin/bash -e
: "${gcloud_project_id:?}"
: "${gcloud_region:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${zone_devops_bucket:?}"
: "${zone_slack_webhook:?}"
: "${zone_builds_slack_channel:?}"

function finish {
  rm -rf /tmp/gcloud-zone-slack
}
trap finish EXIT

cp -r "${taito_plugin_path}/resources/slack" /tmp/gcloud-zone-slack
cat "/tmp/gcloud-zone-slack/config-template.json" | \
  sed "s|\\[SLACK_WEBHOOK_URL\\]|${zone_slack_webhook}|" | \
  sed "s|\\[BUILDS_CHANNEL\\]|${zone_builds_slack_channel}|" \
  > "/tmp/gcloud-zone-slack/config.json"

cp "${taito_project_path}/projects.json" "/tmp/gcloud-zone-slack"

echo "Deploying the following settings:"
cat "/tmp/gcloud-zone-slack/config.json"
cat "/tmp/gcloud-zone-slack/projects.json"

gcloud --project "${gcloud_project_id}" \
  functions deploy cloudBuildSlackNotifications \
  --source "/tmp/gcloud-zone-slack" \
  --stage-bucket "${zone_devops_bucket}" \
  --trigger-topic cloud-builds \
  --entry-point subscribe \
  --region "europe-west1"

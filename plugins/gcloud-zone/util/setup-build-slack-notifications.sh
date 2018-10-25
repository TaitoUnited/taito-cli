#!/bin/bash -e
: "${gcloud_project_id:?}"
: "${gcloud_region:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${zone_devops_bucket:?}"
: "${zone_slack_webhook:?}"
: "${zone_builds_slack_channel:?}"

function finish {
  rm -rf "${taito_plugin_path}/resources/slack/projects.json"
  rm -rf "${taito_plugin_path}/resources/slack/config.json"
}
trap finish EXIT

cat "${taito_plugin_path}/resources/slack/config-template.json" | \
  sed "s|\\[SLACK_WEBHOOK_URL\\]|${zone_slack_webhook}|" | \
  sed "s|\\[BUILDS_CHANNEL\\]|${zone_builds_slack_channel}|" \
  > "${taito_plugin_path}/resources/slack/config.json"

cp "${taito_project_path}/projects.json" "${taito_plugin_path}/resources/slack"

echo "Deploying the following settings:"
cat "${taito_plugin_path}/resources/slack/config.json"
cat "${taito_plugin_path}/resources/slack/projects.json"

gcloud --project "${gcloud_project_id}" \
  functions deploy cloudBuildSlackNotifications \
  --source "${taito_plugin_path}/resources/slack" \
  --stage-bucket "${zone_devops_bucket}" \
  --trigger-topic cloud-builds \
  --entry-point subscribe \
  --region "europe-west1"

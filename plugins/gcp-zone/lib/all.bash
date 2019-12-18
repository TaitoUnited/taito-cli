#!/bin/bash

# TODO: move to Terraform module
function gcp-zone::setup_cloud_build_slack_notifications () {
  function finish {
    rm -rf /tmp/gcp-zone-slack
  }

  trap finish EXIT

  cp -r "${taito_plugin_path:?}/resources/slack" /tmp/gcp-zone-slack
  cat "/tmp/gcp-zone-slack/config-template.json" | \
    sed "s|\\[SLACK_WEBHOOK_URL\\]|${taito_messaging_webhook:?}|" | \
    sed "s|\\[BUILDS_CHANNEL\\]|${taito_messaging_builds_channel:?}|" \
    > "/tmp/gcp-zone-slack/config.json"

  cp "${taito_project_path:?}/projects.json" "/tmp/gcp-zone-slack"

  echo "Deploying the following settings:"
  cat "/tmp/gcp-zone-slack/config.json"
  cat "/tmp/gcp-zone-slack/projects.json"

  gcloud --project "${taito_zone:?}" \
    functions deploy cloudBuildSlackNotifications \
    --source "/tmp/gcp-zone-slack" \
    --runtime nodejs10 \
    --stage-bucket "${taito_projects_bucket:?}" \
    --trigger-topic cloud-builds \
    --entry-point subscribe \
    --region "europe-west1"
}

function gcp-zone::teardown_cloud_build_slack_notifications() {
  gcloud --project "${taito_zone:?}" \
    functions delete cloudBuildSlackNotifications \
    --region "europe-west1"
}

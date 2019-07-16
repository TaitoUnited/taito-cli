#!/bin/bash

# TODO: duplicate methods with gcp plugin?

function gcp-zone::authenticate () {
  local type=${1}
  local account
  account=$(gcloud config get-value account 2> /dev/null)

  if [[ ${account} ]]; then
    echo "Logged in as ${account}"
  fi

  if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || [[ ${type} == "init" ]]; then
    echo -e "${H2s}gcloud init${H2e}"
    # NOTE: removed  --project="${taito_zone}"
    (${taito_setv:?}; gcloud init --console-only)
  fi

  if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || [[ ${type} == "default" ]]; then
    echo -e "${H2s}gcloud auth application-default login${H2e}"
    (${taito_setv:?}; gcloud auth application-default login)
  fi

  if [[ -n "${kubernetes_name:-}" ]]; then
    if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]]; then
      echo -e "${H2s}gcloud container clusters get-credentials${H2e}"
      "${taito_plugin_path}/util/get-credentials-kube" || (
        echo "WARNING: Kubernetes authentication failed."
        echo "NOTE: Authentication failure is OK if the Kubernetes cluster does not exist yet."
      )
    fi
  fi
}

function gcp-zone::authenticate_on_kubernetes () {
  (${taito_setv:?}; gcloud container clusters get-credentials "${kubernetes_name}" \
    --project "${taito_zone}" --zone "${taito_provider_zone}")
}

function gcp-zone::setup_cloud_build_slack_notifications () {
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
}

function gcp-zone::teardown_cloud_build_slack_notifications() {
  gcloud --project "${taito_zone}" \
    functions delete cloudBuildSlackNotifications \
    --region "europe-west1"
}

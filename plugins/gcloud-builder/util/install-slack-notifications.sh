#!/bin/bash

: "${gcloud_project:?}"
: "${gcloud_region:?}"
: "${gcloud_slack_webhook:?}"

mode=${1:?Select mode: setup or teardown}

export GC_SLACK_STATUS="FAILURE TIMEOUT INTERNAL_ERROR"
export SLACK_WEBHOOK_URL="${gcloud_slack_webhook}"
export PROJECT_ID=${gcloud_project}
export REGION=${gcloud_region}

rm -rf /tmp/google-container-slack && \
git clone https://github.com/Philmod/google-container-slack.git \
  /tmp/google-container-slack && \

cd /tmp/google-container-slack && \
if [[ "${mode}" == "setup" ]]; then
  export BUCKET_NAME=${gcloud_project}-devops
  . ./setup.sh
elif [[ "${mode}" == "teardown" ]]; then
  . ./teardown.sh
else
  echo "Unknown mode: ${mode}"
  exit 1
fi && \

rm -rf /tmp/google-container-slack

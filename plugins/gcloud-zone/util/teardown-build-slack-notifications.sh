#!/bin/bash -e
: "${gcloud_project_id:?}"

gcloud --project "${gcloud_project_id}" \
  functions delete cloudBuildSlackNotifications

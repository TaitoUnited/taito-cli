#!/bin/bash -e
: "${taito_zone:?}"

gcloud --project "${taito_zone}" \
  functions delete cloudBuildSlackNotifications \
  --region "europe-west1"

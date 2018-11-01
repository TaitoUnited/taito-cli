#!/bin/bash
: "${kubectl_name:?}"
: "${taito_zone:?}"
: "${gcloud_zone:?}"

(${taito_setv:?}; gcloud container clusters get-credentials "${kubectl_name}" \
  --project "${taito_zone}" --zone "${gcloud_zone}")

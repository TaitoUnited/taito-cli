#!/bin/bash
: "${kubernetes_name:?}"
: "${taito_zone:?}"
: "${taito_provider_zone:?}"

(${taito_setv:?}; gcloud container clusters get-credentials "${kubernetes_name}" \
  --project "${taito_zone}" --zone "${taito_provider_zone}")

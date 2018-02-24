#!/bin/bash
: "${taito_cli_path:?}"
: "${kubectl_name:?}"
: "${gcloud_zone:?}"

(${taito_setv:?}; gcloud container clusters get-credentials "${kubectl_name}" \
  --zone "${gcloud_zone}")

#!/bin/bash

: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_zone:?}"
: "${gcloud_zone:?}"
: "${kubectl_name:?}"

# We must always set context as context is not saved in the container image
# between runs.
if ! kubectl config set-context "${taito_customer}-${taito_env}" \
  --namespace="${taito_customer}-${taito_env}" \
  --cluster="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}" \
  --user="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}"; then
  exit 1
fi

if ! kubectl config use-context "${taito_customer}-${taito_env}"; then
  exit 1
fi

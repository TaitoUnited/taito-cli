#!/bin/bash

: "${taito_namespace:?}"
: "${taito_zone:?}"
: "${gcloud_zone:?}"
: "${kubectl_name:?}"

# We must always set context as context is not saved in the container image
# between runs.
kubectl config set-context "${taito_namespace}" \
  --namespace="${taito_namespace}" \
  --cluster="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}" \
  --user="gke_${taito_zone}_${gcloud_zone}_${kubectl_name}" && \

kubectl config use-context "${taito_namespace}"

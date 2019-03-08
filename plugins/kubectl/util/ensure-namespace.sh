#!/bin/bash

namespace=${1:?}

# Ensure namespace exists and it uses safe defaults
${taito_setv:?}
kubectl create namespace "${namespace}" &> /dev/null && \
  echo "Namespace ${namespace} created" && \
  kubectl patch serviceaccount default \
    -p "automountServiceAccountToken: false" --namespace "${namespace}"

echo
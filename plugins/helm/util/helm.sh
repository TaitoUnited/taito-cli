#!/bin/bash -e

# Runs tillerless Helm

function finish {
  if [[ ${taito_zone} != "gcloud-temp1" ]]; then
    helm tiller stop > /dev/null
  fi
}
trap finish EXIT

${taito_setv:?}
if [[ ${taito_zone} != "gcloud-temp1" ]]; then
  helm tiller start-ci > /dev/null
  export HELM_HOST=127.0.0.1:44134
fi
helm "${@}"

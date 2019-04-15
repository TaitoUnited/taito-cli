#!/bin/bash -e

# Runs tillerless Helm

function finish {
  helm tiller stop > /dev/null
}
trap finish EXIT

${taito_setv:?}
helm tiller start-ci > /dev/null
export HELM_HOST=127.0.0.1:44134
helm "${@}"

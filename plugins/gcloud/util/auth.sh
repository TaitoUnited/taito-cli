#!/bin/bash
: "${taito_cli_path:?}"

type=${1}

if [[ ${type} == "" ]] || [[ ${type} == "init" ]]; then
  echo "---- gcloud init -----"
  (${taito_setv:?}; gcloud init --console-only --project="${taito_zone}")
fi && \

if [[ ${type} == "" ]] || [[ ${type} == "default" ]]; then
  echo "---- gcloud auth application-default login -----"
  (${taito_setv:?}; gcloud auth application-default login)
fi && \

if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]]; then
  echo "---- gcloud container clusters get-credentials -----"
  "${taito_plugin_path}/util/get-credentials-kube.sh"
fi

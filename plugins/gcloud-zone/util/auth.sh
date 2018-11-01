#!/bin/bash
: "${taito_cli_path:?}"

type=${1}

if [[ ${type} == "" ]] || [[ ${type} == "init" ]]; then
  echo "---- gcloud init -----"
  # NOTE: removed  --project="${taito_zone}"
  (${taito_setv:?}; gcloud init --console-only)
fi && \

if [[ ${type} == "" ]] || [[ ${type} == "default" ]]; then
  echo "---- gcloud auth application-default login -----"
  (${taito_setv:?}; gcloud auth application-default login)
fi && \

if [[ -n "${kubectl_name:-}" ]]; then
  if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]]; then
    echo "---- gcloud container clusters get-credentials -----"
    "${taito_plugin_path}/util/get-credentials-kube.sh" || \
      "WARN: Kubernetes authentication failed. OK if does not exist yet."
  fi
fi

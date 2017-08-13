#!/bin/bash
: "${taito_cli_path:?}"

type=${1}

if [[ ${type} == "" ]] || [[ ${type} == "init" ]]; then
  echo
  echo "---- gcloud init -----"
  if ! gcloud init --console-only --project="${taito_zone}"; then
    exit 1
  fi
fi

if [[ ${type} == "" ]] || [[ ${type} == "default" ]]; then
  echo
  echo "---- gcloud auth application-default login -----"
  if ! gcloud auth application-default login; then
    exit 1
  fi
fi

if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]]; then
  echo
  echo "---- gcloud container clusters get-credentials -----"
  if ! "${taito_plugin_path}/util/get-credentials-kube.sh"; then
    exit 1
  fi
fi

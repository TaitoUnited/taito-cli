#!/bin/bash
: "${taito_util_path:?}"

type=${1}
account=$(gcloud config get-value account 2> /dev/null)

if [[ ${account} ]]; then
  echo "Logged in as ${account}"
fi

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || [[ ${type} == "init" ]]; then
  echo "---- gcloud init -----"
  # NOTE: removed  --project="${taito_zone}"
  (${taito_setv:?}; gcloud init --console-only)
fi && \

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || [[ ${type} == "default" ]]; then
  echo "---- gcloud auth application-default login -----"
  (${taito_setv:?}; gcloud auth application-default login)
fi && \

if [[ -n "${kubernetes_name:-}" ]]; then
  if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]]; then
    echo "---- gcloud container clusters get-credentials -----"
    "${taito_plugin_path}/util/get-credentials-kube.sh" || (
      echo "WARNING: Kubernetes authentication failed."
      echo "NOTE: Authentication failure is OK if the Kubernetes cluster does not exist yet."
    )
  fi
fi

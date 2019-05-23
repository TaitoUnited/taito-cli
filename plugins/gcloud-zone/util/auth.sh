#!/bin/bash
: "${taito_util_path:?}"

type=${1}
account=$(gcloud config get-value account 2> /dev/null)

if [[ ${account} ]]; then
  echo "Logged in as ${account}"
fi

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || [[ ${type} == "init" ]]; then
  echo -e "${H2s}gcloud init${H2e}"
  # NOTE: removed  --project="${taito_zone}"
  (${taito_setv:?}; gcloud init --console-only)
fi && \

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || [[ ${type} == "default" ]]; then
  echo -e "${H2s}gcloud auth application-default login${H2e}"
  (${taito_setv:?}; gcloud auth application-default login)
fi && \

if [[ -n "${kubernetes_name:-}" ]]; then
  if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]]; then
    echo -e "${H2s}gcloud container clusters get-credentials${H2e}"
    "${taito_plugin_path}/util/get-credentials-kube.sh" || (
      echo "WARNING: Kubernetes authentication failed."
      echo "NOTE: Authentication failure is OK if the Kubernetes cluster does not exist yet."
    )
  fi
fi

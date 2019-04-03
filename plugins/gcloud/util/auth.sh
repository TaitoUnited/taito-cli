#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

type=${1}
account=$(gcloud config get-value account 2> /dev/null)

if [[ ${account} ]]; then
  echo "You are already logged in as ${account}."
  echo "In case of trouble, you can run 'taito auth:${taito_env} reset'"
  echo
fi

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
    [[ ${type} == "init" ]] || [[ ${type} == "reset" ]]
then
  echo "# gcloud init"
  # TODO run 'gcloud auth revoke ${account}' ?
  (${taito_setv:?}; gcloud init --console-only)
fi && \

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
    [[ ${type} == "login" ]] || [[ ${type} == "reset" ]]
then
  echo "# gcloud auth application-default login"
  # TODO run 'gcloud auth revoke ${account}' ?
  (${taito_setv:?}; gcloud auth application-default login)
fi && \

if [[ -n "${kubectl_name:-}" ]]; then
  if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]] || [[ ${type} == "reset" ]]
  then
    echo "# gcloud container clusters get-credentials"
    "${taito_plugin_path}/util/get-credentials-kube.sh" || \
      "WARN: Kubernetes authentication failed. OK if the cluster does not exist yet."
  fi
fi

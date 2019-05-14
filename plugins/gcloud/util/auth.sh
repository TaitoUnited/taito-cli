#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"

# TODO: support for '--reset'

type=${1}
account=$(gcloud config get-value account 2> /dev/null)

if [[ ${account} ]]; then
  echo "You are already authenticated as ${account}."
  echo "You can reauthenticate with 'taito auth:${taito_env} reset'."
  echo
fi

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
    [[ ${type} == "init" ]] || [[ ${type} == "reset" ]]
then
  echo "gcloud init"
  # TODO run 'gcloud auth revoke ${account}' ?
  (${taito_setv:?}; gcloud init --console-only)
fi && \

if ( [[ ${type} == "" ]] && [[ ! ${account} ]] ) || \
    [[ ${type} == "login" ]] || [[ ${type} == "reset" ]]
then
  echo "gcloud auth application-default login"
  # TODO run 'gcloud auth revoke ${account}' ?
  (${taito_setv:?}; gcloud auth application-default login)
fi && \

if [[ -n "${kubernetes_name:-}" ]]; then
  if [[ ${type} == "" ]] || [[ ${type} == "cluster" ]] || [[ ${type} == "reset" ]]
  then
    "${taito_cli_path}/plugins/gcloud/util/get-credentials-kube.sh" || (
      echo "WARNING: Kubernetes authentication failed."
      echo "NOTE: Authentication failure is OK if the Kubernetes cluster does not exist yet."
    )
  fi
fi

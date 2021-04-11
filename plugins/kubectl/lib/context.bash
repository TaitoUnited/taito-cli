#!/bin/bash -e

function kubectl::ensure_namespace () {
  local namespace=${1:?}

  (
    # Ensure namespace exists and it uses safe defaults
    taito::executing_start
    kubectl create namespace "${namespace}" &> /dev/null && \
      echo "Namespace ${namespace} created" && \
      kubectl patch serviceaccount default \
        -p "automountServiceAccountToken: false" --namespace "${namespace}" || :
  )
}

function kubectl::use_context () {
  : "${kubernetes_cluster:?}"
  : "${taito_dout:?}"

  local context="${taito_namespace:-$taito_zone}"
  local namespace="${taito_namespace:-kube-system}"

  # We must always set context as context is not saved in the container image
  # between runs.
  (
    local user=${kubernetes_user:-$kubernetes_cluster}
    user=${kubernetes_admin:-$user}
    taito::executing_start
    kubectl config set-context "${context}" \
      --namespace="${namespace}" \
      --cluster="${kubernetes_cluster}" \
      --user="${user}" > "${taito_dout}"

    kubectl config use-context "${context}" > "${taito_dout}"
  )
}

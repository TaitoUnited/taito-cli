#!/bin/bash
: "${taito_zone:?}"
: "${kubernetes_cluster:?}"
: "${taito_dout:?}"

context="${taito_namespace:-$taito_zone}"
namespace="${taito_namespace:-kube-system}"

# We must always set context as context is not saved in the container image
# between runs.
(
  user=${kubernetes_user:-$kubernetes_cluster}
  ${taito_setv:?}
  kubectl config set-context "${context}" \
    --namespace="${namespace}" \
    --cluster="${kubernetes_cluster}" \
    --user="${user}" > "${taito_dout}" && \

  kubectl config use-context "${context}" > "${taito_dout}"
)

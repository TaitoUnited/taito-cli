#!/bin/bash
: "${taito_zone:?}"
: "${kubectl_cluster:?}"
: "${kubectl_user:?}"
: "${taito_dout:?}"

context="${taito_namespace:-$taito_zone}"
namespace="${taito_namespace:-kube-system}"

# We must always set context as context is not saved in the container image
# between runs.
(
  ${taito_setv:?}
  kubectl config set-context "${context}" \
    --namespace="${namespace}" \
    --cluster="${kubectl_cluster}" \
    --user="${kubectl_user}" > "${taito_dout}" && \

  kubectl config use-context "${context}" > "${taito_dout}"
)

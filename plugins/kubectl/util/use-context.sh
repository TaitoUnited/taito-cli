#!/bin/bash
: "${taito_namespace:?}"
: "${taito_zone:?}"
: "${kubectl_cluster:?}"
: "${kubectl_user:?}"
: "${taito_vout:?}"

# We must always set context as context is not saved in the container image
# between runs.
(
  ${taito_setv:?}
  kubectl config set-context "${taito_namespace}" \
    --namespace="${taito_namespace}" \
    --cluster="${kubectl_cluster}" \
    --user="${kubectl_user}" > "${taito_vout}" && \

  kubectl config use-context "${taito_namespace}" > "${taito_vout}"
)

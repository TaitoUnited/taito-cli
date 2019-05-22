#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_env:?}"
: "${taito_namespace:?}"

name=${1}

"${taito_plugin_path}/util/use-context.sh" && \

if "${taito_util_path}/confirm-execution.sh" "kubectl-delete-secrets" "${name}" \
  "Delete secrets of namespace ${taito_namespace} from Kubernetes"
then
  "${taito_plugin_path}/util/delete-secrets.sh"
fi && \

if "${taito_util_path}/confirm-execution.sh" "kubectl-delete-namespace" "${name}" \
  "Delete namespace ${taito_namespace} from Kubernetes"
then
  (${taito_setv:?}; kubectl delete namespace "${taito_namespace}" || :)
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"
: "${taito_namespace:?}"

name="${1}"

if "${taito_util_path}/confirm-execution.sh" "helm" "${name}" \
  "Delete and purge helm release ${taito_project}-${taito_target_env}"
then
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh"
  (
    ${taito_setv:?}
    "${taito_plugin_path}/util/helm.sh" delete --purge \
      "${taito_project}-${taito_target_env}"
  ) || echo "WARNING: Deleting helm release failed. Have you ever deployed?"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

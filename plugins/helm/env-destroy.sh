#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"
: "${taito_namespace:?}"

echo "Delete and purge helm release ${taito_project}-${taito_target_env} (Y/n)?" && \
read -r confirm && \
if [[ "${confirm}" =~ ^[Yy]*$ ]]; then
  "${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \
  (${taito_setv:?}; helm delete --purge "${taito_project}-${taito_target_env}") || \
  echo "WARNING: Deleting helm release failed. Have you ever deployed?"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

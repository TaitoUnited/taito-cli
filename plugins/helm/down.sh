#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"

echo "Deleting ${taito_project}-${taito_target_env}. This may also delete data that"
echo "has been stored on a persistent volume. Do you really want to continue (y/N)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

(
  ${taito_setv:?}
  "${taito_plugin_path}/util/helm.sh" delete --purge \
    "${taito_project}-${taito_target_env}"
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

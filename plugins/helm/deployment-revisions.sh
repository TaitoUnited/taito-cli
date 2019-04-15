#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"
(
  ${taito_setv:?}
  "${taito_plugin_path}/util/helm.sh" history \
    "${taito_project}-${taito_target_env}"
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

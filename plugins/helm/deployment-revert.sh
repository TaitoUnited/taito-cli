#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"
: "${taito_target_env:?}"

revision="${1:-0}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh"
(
  ${taito_setv:?}
  "${taito_plugin_path}/util/helm.sh" rollback \
    "${taito_project}-${taito_target_env}" "${revision}"
)

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

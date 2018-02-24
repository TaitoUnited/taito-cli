#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

"${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \
if [[ "${taito_mode:-}" != "ci" ]] || [[ "${ci_exec_deploy:-}" != "false" ]]; then
  "${taito_plugin_path}/util/deploy.sh" "${@}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

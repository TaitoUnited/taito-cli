#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_project:?}"

"${taito_plugin_path}/util/use-context.sh" && \

. "${taito_plugin_path}/util/determine-pods.sh"

(${taito_setv:?}; kubectl delete pod ${pods}) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

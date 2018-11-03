#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

echo "Setting default namespace: ${taito_namespace:-kube-system}"
"${taito_plugin_path}/util/use-context.sh"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

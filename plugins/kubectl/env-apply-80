#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

echo "Confirming restart, if restart is required"
"${taito_plugin_path}/util/use-context.sh"
"${taito_plugin_path}/util/restart-all.sh"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"
: "${taito_env:?}"

echo
echo "### docker-compose/post: Showing information"
echo
"${taito_plugin_path}/util/restart-all.sh"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

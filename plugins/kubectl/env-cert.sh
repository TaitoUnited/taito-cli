#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

echo "kubectl: TODO implement" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

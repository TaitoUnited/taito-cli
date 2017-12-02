#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_customer:?}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

echo "kubectl: TODO not implemented" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

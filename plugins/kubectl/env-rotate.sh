#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

name_filter="${1}"

echo "Saving secrets to Kubernetes"

# Ensure that namespace exists
kubectl create namespace "${taito_namespace}" 2> /dev/null

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

"${taito_plugin_path}/util/save-secrets.sh" "${name_filter}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

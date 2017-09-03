#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

echo
echo "### kubectl - ci-deploy: Deploying application to Kubernetes ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

"${taito_plugin_path}/util/deploy.sh" "${@}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

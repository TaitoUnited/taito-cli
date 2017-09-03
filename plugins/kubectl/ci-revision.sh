#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

echo
echo "### kubectl - ci-revision: Showing current revision of ${taito_env} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

helm list | grep "${taito_project_env}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

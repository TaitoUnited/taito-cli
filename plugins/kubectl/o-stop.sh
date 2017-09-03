#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

echo
echo "### kubectl - o-stop: Stopping application on ${taito_env} ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

echo "TODO scale replicas to 0 instead of deleting" && \
helm delete --purge "${taito_project_env}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

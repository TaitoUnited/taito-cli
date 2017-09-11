#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"
: "${taito_project:?}"

echo
echo "### kubectl - ci-revert: Reverting application in ${taito_env} ###"

revision="${1:-0}"

# Change namespace
"${taito_plugin_path}/util/use-context.sh" && \

helm rollback "${taito_project_env}" "${revision}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

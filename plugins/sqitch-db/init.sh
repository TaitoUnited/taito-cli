#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"

switches=" ${*} "

if [[ "${switches}" == *"--clean"* ]]; then
  echo "Rebasing database ${database_name}"
  "${taito_plugin_path}/util/sqitch.sh" rebase --set env="'${taito_env}'"
else
  echo "Deploying changes to database ${taito_env}" && \
  "${taito_plugin_path}/util/deploy-changes.sh"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

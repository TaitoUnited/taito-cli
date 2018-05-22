#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"

(
  databases=("${taito_target:-$taito_databases}")
  for database in ${databases[@]}
  do
    export taito_target="${database}"
    . "${taito_util_path}/read-database-config.sh" "${database}" && \

    echo "Deploying changes to database ${taito_env}" && \
    "${taito_plugin_path}/util/deploy-changes.sh" "${@}"
  done
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

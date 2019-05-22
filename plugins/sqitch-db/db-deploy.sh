#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"

(
  all=$("$taito_util_path/get-targets-by-type.sh" database)
  databases=("${taito_target:-$all}")
  for database in ${databases[@]}
  do
    export taito_target="${database}"
    . "${taito_util_path}/read-database-config.sh" "${database}" && \

    echo "Deploying changes to database ${taito_env}" && \
    "${taito_plugin_path}/util/deploy-changes.sh" "${@}"
  done
) && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

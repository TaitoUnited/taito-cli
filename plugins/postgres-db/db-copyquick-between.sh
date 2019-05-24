#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_dest_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
  source="${taito_env}"
  dest="${taito_dest_env}"
  username="${1:-postgres}"

  echo "Copying ${source} to ${dest}"
  echo "NOTE: This works only if both databases are located in the same database cluster."
  echo "WARNING! THIS HAS NOT BEEN TESTED AT ALL YET! Use db-copy:ENV instead!"
  echo "WARNING! This operation will disconnect all connections!"
  "$taito_util_path/confirm.sh"

  db_prefix=${database_name%_*}

  flags="-f ${taito_plugin_path}/resources/copyquick.sql \
    -v dbusermaster=${database_master_username:-postgres} \
    -v source=${database_name} \
    -v dest=${db_prefix}_${dest} \
    -v dest_old=${db_prefix}_${dest}_old \
    -v dest_app=${db_prefix}_${dest}_app"
  echo 'TODO implement: dest is ${database_name}, source is something else'
  exit 1
  "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

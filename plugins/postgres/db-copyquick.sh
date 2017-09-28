#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

dest="${taito_env}"
source="${1:?Source not given}"
username="${2}"

echo
echo "### postgres - db-copyquick: Copying database from ${source} \
to ${dest} ###"
echo "NOTE: This works only if both databases are located in the same \
database cluster."
echo "WARNING! THIS HAS NOT BEEN TESTED AT ALL YET! Use db-copy:ENV instead!"
echo "WARNING! This operation will disconnect all connections! Continue (Y/n)?"
read -r confirm

if [[ ${confirm} =~ ^[Yy]$ ]]; then
  db_prefix=${postgres_database%_*}

  flags="-f ${taito_plugin_path}/resources/copyquick.sql \
    -v source=${postgres_database} \
    -v dest=${db_prefix}_${dest} \
    -v dest_old=${db_prefix}_${dest}_old" \
    -v dest_app=${db_prefix}_${dest}_app"
  "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

dest="${taito_env}"
source="${1:?Source not given}"
username="${2}"

echo "NOTE: This works only if both databases are located in the same \
database cluster."
echo "WARNING! THIS HAS NOT BEEN TESTED AT ALL YET! Use db-copy:ENV instead!"
echo "WARNING! This operation will disconnect all connections! Continue (Y/n)?"
read -r confirm

if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

db_prefix=${database_name%_*}

flags="-f ${taito_plugin_path}/resources/copyquick.sql \
  -v source=${database_name} \
  -v dest=${db_prefix}_${dest} \
  -v dest_old=${db_prefix}_${dest}_old" \
  -v dest_app=${db_prefix}_${dest}_app"
echo 'TODO implement: dest is ${database_name}, source is something else'
exit 1
"${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

source="${taito_env}"
dest="${1}"
username="${2:-postgres}"

echo
echo "### postgres - db-copy: Copying database from ${source} to ${dest} ###"
echo

db_prefix=${postgres_database%_*}
db_dest=${postgres_database%_*}_${dest}
db_source=${postgres_database%_*}_${source}

echo "- 1. Dump data"
dump_file="${taito_project_path}/tmp/dump.sql"
mkdir -p "${taito_project_path}/tmp" &> /dev/null
rm -f "${dump_file}" &> /dev/null
if ! "${taito_plugin_path}/util/psql.sh" "" "-f ${dump_file}" "pg_dump"; then
  exit 1
fi

echo "- 2. Rename the old database"
. "${taito_plugin_path}/util/ask-password.sh" # TODO Does not work. Why?
flags="-f ${taito_plugin_path}/resources/rename-db.sql -v database=${db_dest} -v database_new=${db_dest}_old"
if ! "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"; then
  exit 1
fi

echo "- 3. Create database"
echo "NOTE: use taito secrets:${dest} to get the build password for ${db_dest}"
# TODO pass username
# TODO set also cluster name and port
postgres_username=${username} postgres_database=${db_prefix}_${dest} \
  "${taito_plugin_path}/util/create-database.sh"

echo "- 4. Import dump with a new build username"
sed -e "s/${db_source}/${db_dest}/g" \
  "${dump_file}" > \
  "${taito_project_path}/tmp/dump-mod.sql"
flags="-f ${taito_project_path}/tmp/dump-mod.sql"
if ! postgres_database=${db_prefix}_${dest} "${taito_plugin_path}/util/psql.sh" "" "${flags}"; then
  exit 1
fi

rm -f "${taito_project_path}/tmp/dump-mod.sql"
rm -f "${dump_file}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

username="${1}"

echo
echo "### postgres - db-dump: Dumping database ${postgres_database} ###"
echo
echo "host: ${postgres_host} port:${postgres_port}"
echo

dump_file="${taito_project_path}/tmp/dump.sql"
mkdir -p "${taito_project_path}/tmp" &> /dev/null

"${taito_plugin_path}/util/psql.sh" "${username}" "-f ${dump_file}" "pg_dump" && \

echo && \
echo "Dump file location: ${dump_file}" && \
echo && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

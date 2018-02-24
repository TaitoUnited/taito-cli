#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

username="${1}"

echo "host: ${database_host} port:${database_port}"

dump_file="${taito_project_path}/tmp/dump.sql"
mkdir -p "${taito_project_path}/tmp" &> /dev/null

"${taito_plugin_path}/util/psql.sh" "${username}" "-f ${dump_file}" "pg_dump" && \

echo "Dump file location: ${dump_file}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

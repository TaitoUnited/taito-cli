#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "postgres" ]] || [[ -z "${database_type}" ]]; then
  dump_file="${1:?}"
  username=""

  echo "Dumping database ${database_name} to ${dump_file}. Please wait..."
  "${taito_plugin_path}/util/psql.sh" "${username}" \
    "-f ${dump_file}" "pg_dump"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

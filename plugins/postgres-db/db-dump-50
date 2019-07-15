#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
  dump_file="${1:?}"
  username=""

  echo "Dumping database ${database_name} to ${dump_file}. Please wait."
  "${taito_plugin_path}/util/psql.sh" "${username}" \
    "-f ${dump_file}" "pg_dump"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

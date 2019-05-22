#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
  username="${1}"
  "${taito_plugin_path}/util/psql.sh" "${username}"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

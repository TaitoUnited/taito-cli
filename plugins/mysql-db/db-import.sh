#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

if [[ "${database_type:-}" == "mysql" ]] || [[ -z "${database_type}" ]]; then
  "${taito_plugin_path}/util/mysql.sh" < "${1}"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

if [[ "${database_type:-}" == "pg" ]] || [[ -z "${database_type}" ]]; then
  filename="${1:?Filename not given}"
  username="${2}"

  (
    cd "${taito_current_path}"
    flags="-f ${filename}"
    "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

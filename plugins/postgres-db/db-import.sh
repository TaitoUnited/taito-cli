#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

filename="${1:?Filename not given}"
username="${2}"

echo "host: ${database_host} port:${database_port}"

(
  cd "${taito_current_path}"
  flags="-f ${filename}"
  "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

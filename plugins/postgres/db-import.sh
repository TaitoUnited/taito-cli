#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

filename="${1:?Filename not given}"
username="${2}"

echo
echo "### postgres - db-open: Connecting to database ${postgres_database} ###"
echo "host: ${postgres_host} port:${postgres_port}"

(
  cd "${taito_current_path}"
  flags="-f ${filename}"
  "${taito_plugin_path}/util/psql.sh" "${username}" "${flags}"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

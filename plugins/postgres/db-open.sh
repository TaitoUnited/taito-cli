#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

username="${1}"

echo
echo "### postgres - db-open: Connecting to database ${postgres_database} ###"
echo
echo "host: ${postgres_host} port:${postgres_port}"
echo

if ! "${taito_plugin_path}/util/psql.sh" "${username}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

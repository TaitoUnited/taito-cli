#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

filename="${1}"
username="${2}"

echo
echo "### postgres - db-open: Connecting to database ${postgres_database} ###"
echo
echo "host: ${postgres_host} port:${postgres_port}"
echo

if ! (
  cd "${taito_current_path}"
  flags="-f ${filename}"
  if ! "${taito_plugin_path}/util/psql.sh" "'${username}'" "'${flags}'"; then
    exit 1
  fi
); then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

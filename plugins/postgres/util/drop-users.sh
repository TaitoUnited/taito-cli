#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"
: "${postgres_username:?}"

echo "- import drop-users.sql:"
psql -h "${postgres_host}" \
  -p "${postgres_port}" \
  -U "${postgres_username}" \
  -f "${taito_plugin_path}/resources/drop-users.sql" \
  -v "database=${postgres_database}" \
  -v "dbuserapp=${postgres_database}_app"
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

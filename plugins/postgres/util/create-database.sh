#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"
: "${postgres_username:?}"

echo
echo "- import create.sql"
PGPASSWORD="${PGPASSWORD}" psql -h "${postgres_host}" \
  -p "${postgres_port}" -U "${postgres_username}" \
  -f "${taito_plugin_path}/resources/create.sql" \
  -v "database=${postgres_database}" \
  -v "dbuserapp=${postgres_database}_app"
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

echo
echo "- import ./database/init.sql"
PGPASSWORD="${PGPASSWORD}" psql -h "${postgres_host}" \
  -p "${postgres_port}" -d "${postgres_database}" \
   -U "${postgres_username}" < ./database/init.sql
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

. "${taito_plugin_path}/util/postgres-username-password.sh"

echo
echo "- import grant.sql"
PGPASSWORD="${secret_value}" \
  psql -h "${postgres_host}" -p "${postgres_port}" \
  -d "${postgres_database}" \
  -U "${postgres_database}" \
  -f "${taito_plugin_path}/resources/grant.sql" \
  -v "database=${postgres_database}" \
  -v "dbuserapp=${postgres_database}_app"
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

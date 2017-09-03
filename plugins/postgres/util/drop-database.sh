#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

echo "--- Deleting database ${postgres_database} ---"
echo "Are you sure you want to drop database ${postgres_database} (Y/n)?"
read -r confirm
if [[ ${confirm} =~ ^[Yy]$ ]]; then
  echo "- import drop.sql:"
  psql -h "${postgres_host}" \
    -p "${postgres_port}" \
    -U "${postgres_username}" \
    -f "${taito_plugin_path}/resources/drop.sql" \
    -v "database=${postgres_database}" \
    -v "databaseold=${postgres_database}_old"
fi

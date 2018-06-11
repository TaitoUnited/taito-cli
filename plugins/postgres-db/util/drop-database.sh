#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

echo "--- Deleting database ${database_name} ---"
echo "Are you sure you want to drop database ${database_name} (y/N)?"
read -r confirm
if [[ ${confirm} =~ ^[Yy]$ ]]; then
  echo "- import drop.sql:"
  ${taito_setv:?}
  psql -h "${database_host}" \
    -p "${database_port}" \
    -U "${database_username}" \
    -f "${taito_plugin_path}/resources/drop.sql" \
    -v "database=${database_name}" \
    -v "databaseold=${database_name}_old"
fi

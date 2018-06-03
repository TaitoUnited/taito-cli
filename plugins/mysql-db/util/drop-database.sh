#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

echo "--- Deleting database ${database_name} ---"
echo "Are you sure you want to drop database ${database_name} (Y/n)?"
read -r confirm
if [[ ${confirm} =~ ^[Yy]$ ]]; then
  echo "- import drop.sql:"
  ${taito_setv:?}
  mysql -h "${database_host}" \
    -P "${database_port}" \
    -u "${database_username}" \
    -e "set @database='${database_name}'; set @databaseold='${database_name}old'; source ${taito_plugin_path}/resources/drop.sql ;"
fi

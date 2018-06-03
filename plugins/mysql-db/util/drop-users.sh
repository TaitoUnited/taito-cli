#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

echo "- import drop-users.sql:"
${taito_setv:?}
mysql -h "${database_host}" \
  -P "${database_port}" \
  -u "${database_username}" \
  -e "set @database='${database_name}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}ap'; source ${taito_plugin_path}/resources/drop-users.sql ;"

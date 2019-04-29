#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

${taito_setv:?}
mysql -h "${database_host}" \
  -P "${database_port}" \
  -D mysql \
  -u "${database_username}" \
  -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; source ${taito_plugin_path}/resources/drop-users.sql ;" \
  > ${taito_vout}

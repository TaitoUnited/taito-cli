#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

(
  export MYSQL_PWD
  echo
  echo "- import create.sql"
  MYSQL_PWD="${MYSQL_PWD}"
  (
    ${taito_setv:?}
    mysql -h "${database_host}" \
      -P "${database_port}" \
      -u "${database_username}" \
      -e "set @database='${database_name}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}ap'; source ${taito_plugin_path}/resources/create.sql ;"
  ) && \

  echo
  echo "- import ./${taito_target:-database}/init.sql"
  (
    ${taito_setv:?}
    mysql -h "${database_host}" \
    -P "${database_port}" \
    -D "${database_name}" \
    -u "${database_username}" \
    -e "source ./${taito_target:-database}/init.sql ;"
  )
)

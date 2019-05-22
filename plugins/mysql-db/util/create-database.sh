#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

(
  export MYSQL_PWD
  MYSQL_PWD="${MYSQL_PWD}"
  (
    ${taito_setv:?}
    mysql -h "${database_host}" \
      -P "${database_port}" \
      -D mysql \
      -u "${database_username}" \
      -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; source ${taito_plugin_path}/resources/create.sql ;" \
      > ${taito_vout}
  ) && \

  if [[ -f "./${taito_target:-database}/db.sql" ]]; then
    (
      ${taito_setv:?}
      mysql -h "${database_host}" \
      -P "${database_port}" \
      -D "${database_name}" \
      -u "${database_username}" \
      -e "source ./${taito_target:-database}/db.sql ;" > ${taito_vout}
    )
  else
    echo "WARNING: File ./${taito_target:-database}/db.sql does not exist"
  fi
)

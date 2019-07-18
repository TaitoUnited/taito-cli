#!/bin/bash

function mysql::create_database () {
  (
    export MYSQL_PWD
    MYSQL_PWD="${MYSQL_PWD}"
    (
      taito::executing_start
      mysql -h "${database_host}" \
        -P "${database_port}" \
        -D mysql \
        -u "${database_username}" \
        -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; source ${taito_plugin_path}/resources/create.sql ;" \
        > ${taito_vout}
    )

    if [[ -f "./${taito_target:-database}/db.sql" ]]; then
      (
        taito::executing_start
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
}

function mysql::drop_database () {
  taito::executing_start
  mysql -h "${database_host}" \
    -P "${database_port}" \
    -D mysql \
    -u "${database_username}" \
    -e "set @database='${database_name}'; set @databaseold='${database_name}old'; source ${taito_plugin_path}/resources/drop.sql ;" \
    > ${taito_vout}
}

function mysql::create_users () {
  taito::expose_db_user_credentials

  # Validate env variables

  if [[ ${#database_build_password} -lt 20 ]]; then
    echo "ERROR: Database mgr user password too short or not set"
    exit 1
  fi

  if [[ ${#database_app_password} -lt 20 ]]; then
    echo "ERROR: Database app user password too short or not set"
    echo "TODO: Fails in WordPress projects (there is no app user at all)"
    exit 1
  fi

  # Execute

  taito::executing_start
  mysql -h "${database_host}" \
    -P "${database_port}" \
    -D mysql \
    -u "${database_username}" \
    -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; set @passwordapp='${database_app_password}'; set @passwordmgr='${database_build_password}'; source ${taito_plugin_path}/resources/users.sql ;" \
    > ${taito_vout} 2>&1
}

function mysql::drop_users () {
  taito::executing_start
  mysql -h "${database_host}" \
    -P "${database_port}" \
    -D mysql \
    -u "${database_username}" \
    -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; source ${taito_plugin_path}/resources/drop-users.sql ;" \
    > ${taito_vout}
}

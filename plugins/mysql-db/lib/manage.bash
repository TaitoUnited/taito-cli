#!/bin/bash

function sql_file_path () {
  local name=$1
  if [[ -f "./${taito_target:?}/${name}" ]]; then
    echo "./${taito_target:?}/${name}"
  elif [[ -f "${taito_plugin_path:?}/resources/${name}" ]]; then
    echo "${taito_plugin_path:?}/resources/${name}"
  fi
}

function mysql::create_database () {
  (
    echo "Creating database"
    # export MYSQL_PWD
    # MYSQL_PWD="${MYSQL_PWD}"
    until (
      taito::executing_start
      mysql -p \
        -h "${database_host}" \
        -P "${database_port}" \
        -D mysql \
        -u "${database_username}" \
        -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; source $(sql_file_path create.sql) ;" \
        > "${taito_vout}"
    ) do
      :
    done

    db_file_path="$(sql_file_path db.sql)"
    if [[ ${db_file_path} ]]; then
      echo "Initializing database"
      until (
        taito::executing_start
        mysql -p \
        -h "${database_host}" \
        -P "${database_port}" \
        -D "${database_name}" \
        -u "${database_username}" \
        -e "source ${db_file_path} ;" > "${taito_vout}"
      ) do
        :
      done
    else
      echo "WARNING: File ./${taito_target}/db.sql does not exist"
    fi
  )
}

function mysql::drop_database () {
  echo "Dropping database"
  until (
    taito::executing_start
    mysql -p \
      -h "${database_host}" \
      -P "${database_port}" \
      -D mysql \
      -u "${database_username}" \
      -e "set @database='${database_name}'; set @databaseold='${database_name}old'; source $(sql_file_path drop.sql) ;" \
      > "${taito_vout}"
  ) do
    :
  done
}

function mysql::create_users () {
  echo "Creating users"
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

  until (
    taito::executing_start
    mysql -p \
      -h "${database_host}" \
      -P "${database_port}" \
      -D mysql \
      -u "${database_username}" \
      -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; set @passwordapp='${database_app_password}'; set @passwordmgr='${database_build_password}'; source $(sql_file_path create-users.sql) ;" \
      > "${taito_vout}" 2>&1
  ) do
    :
  done
}

function mysql::drop_users () {
  echo "Dropping users"
  until (
    taito::executing_start
    mysql -p \
      -h "${database_host}" \
      -P "${database_port}" \
      -D mysql \
      -u "${database_username}" \
      -e "set @database='${database_name}'; set @dbusermaster='${database_master_username:-root}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; source $(sql_file_path drop-users.sql) ;" \
      > "${taito_vout}"
  ) do
    :
  done
}

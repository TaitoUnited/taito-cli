#!/bin/bash

function sql_file_path () {
  local name=$1
  if [[ -f "./${taito_target:?}/${name}" ]]; then
    echo "./${taito_target:?}/${name}"
  elif [[ -f "${taito_plugin_path:?}/resources/${name}" ]]; then
    echo "${taito_plugin_path:?}/resources/${name}"
  fi
}

function postgres::create_database () {
  (
    echo "Creating database"
    postgres::export_pgsslmode
    until (
      taito::executing_start
      psql -h "${database_host}" \
        -p "${database_port}" \
        -d postgres \
        -U "${database_username}" \
        -f "$(sql_file_path create.sql)" \
        -v "database=${database_name}" \
        -v "dbusermaster=${database_master_username_internal:-postgres}" \
        -v "dbuserapp=${database_app_username_internal}" > "${taito_vout}"
    ) do
      :
    done

    db_file_path="$(sql_file_path db.sql)"
    if [[ ${db_file_path} ]]; then
      echo "Initializing database"
      until (
        taito::executing_start
        psql -h "${database_host}" \
          -p "${database_port}" \
          -d "${database_name}" \
          -U "${database_username}" \
          < "${db_file_path}" > "${taito_vout}"
      ) do
        :
      done
    else
      echo "WARNING: File ./${taito_target:-database}/db.sql does not exist"
    fi

    taito::expose_db_user_credentials

    echo "Granting user access"
    export PGPASSWORD
    PGPASSWORD="${secret_value}"
    (
      taito::executing_start
      psql -h "${database_host}" \
      -p "${database_port}" \
      -d "${database_name}" \
      -U "${database_build_username}" \
      -f "$(sql_file_path grant-users.sql)" \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username_internal:-postgres}" \
      -v "dbuserapp=${database_app_username_internal}" > "${taito_vout}"
    )
  )
}

function postgres::drop_database () {
  echo "Dropping database"
  postgres::export_pgsslmode
  until (
    taito::executing_start
    psql -h "${database_host}" \
      -p "${database_port}" \
      -d postgres \
      -U "${database_username}" \
      -f "$(sql_file_path drop.sql)" \
      -v "database=${database_name}" \
      -v "databaseold=${database_name}_old" > "${taito_vout}" 2>&1
  ) do
    :
  done
}

function postgres::create_users () {
  echo "Creating users"
  taito::expose_db_user_credentials

  # Validate env variables

  if [[ ${#database_build_password} -lt 20 ]]; then
    echo "ERROR: database_build_password too short or not set"
    exit 1
  fi

  if [[ ${#database_app_password} -lt 20 ]]; then
    echo "ERROR: database_build_password too short or not set"
    exit 1
  fi

  # Execute
  postgres::export_pgsslmode
  until (
    taito::executing_start
    psql -h "${database_host}" -p "${database_port}" \
      -d postgres \
      -U "${database_username}" \
      -f "$(sql_file_path create-users.sql)" \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username_internal:-postgres}" \
      -v "dbuserapp=${database_app_username_internal}" \
      -v "passwordapp=${database_app_password}" \
      -v "passwordbuild=${database_build_password}" \
      > "${taito_vout}" 2>&1
  ) do
    :
  done
}

function postgres::drop_users () {
  echo "Dropping users"
  postgres::export_pgsslmode
  until (
    taito::executing_start
    psql -h "${database_host}" \
      -p "${database_port}" \
      -d postgres \
      -U "${database_username}" \
      -f "$(sql_file_path drop-users.sql)" \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username_internal:-postgres}" \
      -v "dbuserapp=${database_app_username_internal}" > "${taito_vout}"
  ) do
    :
  done
}

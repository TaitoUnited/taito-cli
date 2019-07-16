#!/bin/bash

function postgres::create_database () {
  (
    export PGPASSWORD
    PGPASSWORD="${PGPASSWORD}"
    (
      ${taito_setv:?}
      psql -h "${database_host}" \
        -p "${database_port}" \
        -d postgres \
        -U "${database_username}" \
        -f "${taito_plugin_path}/resources/create.sql" \
        -v "database=${database_name}" \
        -v "dbusermaster=${database_master_username:-postgres}" \
        -v "dbuserapp=${database_name}_app" > ${taito_vout}
    )

    if [[ -f "./${taito_target:-database}/db.sql" ]]; then
      (
        ${taito_setv:?}
        psql -h "${database_host}" \
          -p "${database_port}" \
          -d "${database_name}" \
          -U "${database_username}" \
          < "./${taito_target:-database}/db.sql" > ${taito_vout}
      )
    else
      echo "WARNING: File ./${taito_target:-database}/db.sql does not exist"
    fi

    taito::expose_db_user_credentials

    PGPASSWORD="${secret_value}"
    (
      ${taito_setv:?}
      psql -h "${database_host}" \
      -p "${database_port}" \
      -d "${database_name}" \
      -U "${database_name}" \
      -f "${taito_plugin_path}/resources/grant.sql" \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username:-postgres}" \
      -v "dbuserapp=${database_name}_app" > ${taito_vout}
    )
  )
}

function postgres::drop_database () {
  ${taito_setv:?}
  psql -h "${database_host}" \
    -p "${database_port}" \
    -d postgres \
    -U "${database_username}" \
    -f "${taito_plugin_path}/resources/drop.sql" \
    -v "database=${database_name}" \
    -v "databaseold=${database_name}_old" > ${taito_vout} 2>&1
}

function postgres::create_users () {
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

  ${taito_setv:?}
  psql -h "${database_host}" -p "${database_port}" \
    -d postgres \
    -U "${database_username}" \
    -f "${taito_plugin_path}/resources/users.sql" \
    -v "database=${database_name}" \
    -v "dbusermaster=${database_master_username:-postgres}" \
    -v "dbuserapp=${database_name}_app" \
    -v "passwordapp=${database_app_password}" \
    -v "passwordbuild=${database_build_password}" \
    > ${taito_vout} 2>&1
}

function postgres::drop_users () {
  ${taito_setv:?}
  psql -h "${database_host}" \
    -p "${database_port}" \
    -d postgres \
    -U "${database_username}" \
    -f "${taito_plugin_path}/resources/drop-users.sql" \
    -v "database=${database_name}" \
    -v "dbusermaster=${database_master_username:-postgres}" \
    -v "dbuserapp=${database_name}_app" > ${taito_vout}
}

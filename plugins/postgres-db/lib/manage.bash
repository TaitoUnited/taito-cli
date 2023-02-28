#!/bin/bash

function sql_file_flag () {
  local name=$1
  if [[ -f "./${taito_target:?}/${name}" ]]; then
    echo "-f ./${taito_target:?}/${name}"
  elif [[ -f "${taito_plugin_path:?}/resources/${name}" ]]; then
    echo "-f ${taito_plugin_path:?}/resources/${name}"
  fi
}

function postgres::create_database () {
  (
    echo
    echo "Creating database"
    postgres::export_pgsslmode
    until (
      taito::executing_start
      psql -h "${database_host}" \
        -p "${database_port}" \
        -d "${database_master_database:-postgres}" \
        -U "${database_username}" \
        $(sql_file_flag create.sql) \
        $([[ "${database_viewer_username_internal}" ]] && sql_file_flag create-viewer.sql) \
        -v "database=${database_name}" \
        -v "collate='${database_collate:-fi_FI.UTF-8}'" \
        -v "template=${database_template:-template0}" \
        -v "dbusermaster=${database_master_username_internal:-postgres}" \
        -v "dbuserapp=${database_app_username_internal}" \
        -v "dbuserviewer=${database_viewer_username_internal}" > "${taito_vout}"
    ) do
      :
    done

    db_file_flag="$(sql_file_flag db.sql)"
    if [[ ${db_file_flag} ]]; then
      echo
      echo "Initializing database"
      until (
        taito::executing_start
        psql -h "${database_host}" \
          -p "${database_port}" \
          -d "${database_name}" \
          -U "${database_username}" \
          ${db_file_flag} \
          > "${taito_vout}"
      ) do
        :
      done
    else
      echo "WARNING: File ./${taito_target}/db.sql does not exist"
    fi

    taito::expose_db_user_credentials

    echo
    echo "Granting user access"
    export PGPASSWORD
    PGPASSWORD="${database_build_password}"
    (
      taito::executing_start
      psql -h "${database_host}" \
      -p "${database_port}" \
      -d "${database_name}" \
      -U "${database_build_username}" \
      $(sql_file_flag grant-users.sql) \
      $([[ "${database_viewer_username_internal}" ]] && sql_file_flag grant-users-viewer.sql) \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username_internal:-postgres}" \
      -v "dbuserapp=${database_app_username_internal}" \
      -v "dbuserviewer=${database_viewer_username_internal}" > "${taito_vout}"
    )
  )
}

function postgres::drop_database () {
  echo
  echo "Dropping database"
  postgres::export_pgsslmode
  until (
    taito::executing_start
    psql -h "${database_host}" \
      -p "${database_port}" \
      -d "${database_master_database:-postgres}" \
      -U "${database_username}" \
      $(sql_file_flag drop.sql) \
      -v "database=${database_name}" \
      -v "databaseold=${database_name}_old" > "${taito_vout}" 2>&1
  ) do
    :
  done
}

function postgres::create_users () {
  echo
  echo "Creating users"
  taito::expose_db_user_credentials

  # Validate env variables

  if [[ ${#database_build_password} -lt 20 ]]; then
    echo "ERROR: database_build_password too short or not set"
    exit 1
  fi

  if [[ ${#database_app_password} -lt 20 ]]; then
    echo "ERROR: database_app_password too short or not set"
    exit 1
  fi

  if [[ ! -z "${database_viewer_username_internal}" ]] && [[ ${#database_viewer_password} -lt 20 ]]; then
    echo "ERROR: database_viewer_password too short or not set"
    exit 1
  fi

  # Execute
  postgres::export_pgsslmode
  until (
    taito::executing_start
    psql -h "${database_host}" -p "${database_port}" \
      -d "${database_master_database:-postgres}" \
      -U "${database_username}" \
      $(sql_file_flag create-users.sql) \
      $([[ "${database_viewer_username_internal}" ]] && sql_file_flag create-users-viewer.sql) \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username_internal:-postgres}" \
      -v "dbuserapp=${database_app_username_internal}" \
      -v "dbuserviewer=${database_viewer_username_internal}" \
      -v "passwordapp=${database_app_password:?}" \
      -v "passwordbuild=${database_build_password:?}" \
      -v "passwordviewer=${database_viewer_password:-}" \
      > "${taito_vout}" 2>&1
  ) do
    :
  done
}

function postgres::drop_users () {
  echo
  echo "Dropping users"
  postgres::export_pgsslmode
  until (
    taito::executing_start
    psql -h "${database_host}" \
      -p "${database_port}" \
      -d "${database_master_database:-postgres}" \
      -U "${database_username}" \
      $(sql_file_flag drop-users.sql) \
      $([[ "${database_viewer_username_internal}" ]] && sql_file_flag drop-users-viewer.sql) \
      -v "database=${database_name}" \
      -v "dbusermaster=${database_master_username_internal:-postgres}" \
      -v "dbuserapp=${database_app_username_internal}" \
      -v "dbuserviewer=${database_viewer_username_internal}" > "${taito_vout}"
  ) do
    :
  done
}

#!/bin/bash

function postgres::export_pguser () {
  local username=$1

  export psql_username
  export psql_password

  # TODO: duplicate logic with mysql and mysqldump
  # TODO: needs refactoring

  psql_username="${database_name}_app"
  if [[ ${database_username:-} ]]; then
    psql_username="${database_username}"
  fi
  psql_password="${database_password:-$taito_default_password}"

  if [[ ${username} != "" ]]; then
    psql_username="${username}"
    psql_password=""
  else
    taito::expose_db_user_credentials
    if [[ ${database_default_username} ]] &&
       [[ ${database_default_password} ]]; then
      psql_username="${database_default_username}"
      psql_password="${database_default_password}"
    elif [[ ${database_build_username} ]] &&
       [[ ${database_build_password} ]]; then
      psql_username="${database_build_username}"
      psql_password="${database_build_password}"
    elif [[ ${database_app_username} ]] &&
       [[ ${database_app_password} ]] &&
       [[ ${psql_password} == ${taito_default_password} ]]; then
      psql_username="${database_app_username}"
      psql_password="${database_app_password}"
    elif [[ ${database_build_username} ]]; then
      psql_username="${database_build_username}"
      psql_password="${database_build_password}"
    fi
  fi
}

function postgres::export_pgsslmode () {
  # Set PGSSLMODE
  # TODO: Add support for verify-full

  if [[ ${taito_env:-} == "local" ]]; then
    export PGSSLMODE="prefer"
  elif (
      [[ ${taito_command_requires_db_proxy:-} == "false" ]] &&
      [[ ${database_ssl_enabled:-} == "false" ]]
    ) || (
      [[ ${taito_command_requires_db_proxy:-} == "true" ]] &&
      [[ ${database_proxy_ssl_enabled:-} == "false" ]]
    ); then
    export PGSSLMODE="prefer"
  else
    taito::expose_db_ssl_credentials
    export PGSSLMODE="require"
    export PGSSLROOTCERT="${database_ssl_ca_path}"
    export PGSSLCERT="${database_ssl_cert_path}"
    export PGSSLKEY="${database_ssl_key_path}"
  fi

  # TODO: remove
  if [[ ${taito_zone:-} == "gcloud-temp1" ]]; then
    export PGSSLMODE="prefer"
  fi
}

function postgres::ask_and_expose_password () {
  # HACK: Remove everything after a @. Azure uses @ in usernames, but bash
  # doesn't allow it in variable names
  local passwd_var="${database_username%%@*}_password"
  local passwd="${!passwd_var}"

  if [[ ${passwd} ]]; then
    # Password already set in environment variable
    PGPASSWORD="${passwd}"
  else
    # Ask password from user
    echo "Password for user ${database_username}:"
    read -r -s PGPASSWORD
  fi
}

function postgres::connect () {
  # Use pgcli by default, if it's been installed
  local default_command=$(which pgcli || echo "psql")

  # TODO clean this mess. duplicate code in clean, psql and sqitch
  local username="${1}"
  local flags="${2}"
  local command="${3:-$default_command}"
  (
    postgres::export_pguser "${username}"
    postgres::export_pgsslmode
    export PGPASSWORD="${psql_password}"
    taito::executing_start
    ${command} -h "${database_host}" \
    -p "${database_port}" \
    -d "${database_name}" \
    -U "${psql_username}" \
    ${flags}
  )
}

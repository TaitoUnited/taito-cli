#!/bin/bash

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
  # TODO clean this mess. duplicate code in clean, psql and sqitch

  local username="${1}"
  local flags="${2}"
  local command="${3:-psql}"

  local psql_username
  local psql_password

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
  elif [[ ${taito_env} != "local" ]]; then
    taito::expose_db_user_credentials
    if [[ ${database_build_username} ]] && \
       [[ ${database_build_password} ]]; then
      psql_username="${database_build_username}"
      psql_password="${database_build_password}"
    fi
  fi

  (
    export PGPASSWORD="${psql_password}"
    taito::executing_start
    ${command} -h "${database_host}" \
    -p "${database_port}" \
    -d "${database_name}" \
    -U "${psql_username}" \
    ${flags}
  )
}

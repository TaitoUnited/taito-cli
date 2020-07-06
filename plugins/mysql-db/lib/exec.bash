#!/bin/bash

function mysql::ask_and_expose_password () {
  local passwd_var="${database_username}_password"
  local passwd="${!passwd_var}"

  MYSQL_PWD
  if [[ ${passwd} ]]; then
    # Password already set in environment variable
    MYSQL_PWD="${passwd}"
  else
    # Ask password from user
    echo "Password for user ${database_username}:"
    read -r -s MYSQL_PWD
  fi
}

function mysql::connect () {
  local username="${1}"
  # flags="${2}"
  # command="${3:-mysql}"

  # TODO: duplicate logic with mysqldump and psql
  # TODO: needs refactoring

  local mysql_username
  local mysql_password

  mysql_username="${database_name}a"
  if [[ ${database_username:-} ]]; then
    mysql_username="${database_username}"
  fi
  mysql_password="${database_password:-$taito_default_password}"

  if [[ ${username} != "" ]]; then
    mysql_username="${username}"
    mysql_password=""
  elif [[ ${taito_env} != "local" ]]; then
    taito::expose_db_user_credentials
    if [[ ${database_default_username} ]] &&
       [[ ${database_default_password} ]]; then
      mysql_username="${database_default_username}"
      mysql_password="${database_default_password}"
    elif [[ ${database_build_username} ]] &&
         [[ ${database_build_password} ]]; then
      mysql_username="${database_build_username}"
      mysql_password="${database_build_password}"
    fi
  fi

  if [[ ${mysql_password:-} ]]; then
    (
      export MYSQL_PWD="${mysql_password}"
      taito::executing_start
      mysql -h "${database_host}" -P "${database_port}" -D "${database_name}" \
        -u "${mysql_username}"
    )
  else
    taito::executing_start
    mysql -p -h "${database_host}" -P "${database_port}" -D "${database_name}" \
      -u "${mysql_username}"
  fi
}

function mysql::dump () {
  local username="${1}"
  # flags="${2}"
  # command="${3:-mysql}"

  local mysql_username
  local mysql_password

  mysql_username="${database_name}a"
  if [[ ${database_username:-} ]]; then
    mysql_username="${database_username}"
  fi
  mysql_password="${database_password:-$taito_default_password}"

  if [[ ${username} != "" ]]; then
    mysql_username="${username}"
    mysql_password=""
  elif [[ ${taito_env} != "local" ]]; then
    taito::expose_db_user_credentials
    if [[ ${database_default_username} ]] &&
       [[ ${database_default_password} ]]; then
      mysql_username="${database_default_username}"
      mysql_password="${database_default_password}"
    elif [[ ${database_build_username} ]] &&
       [[ ${database_build_password} ]]; then
      mysql_username="${database_build_username}"
      mysql_password="${database_build_password}"
    fi
  fi

  if [[ ${mysql_password:-} ]]; then
    (
      export MYSQL_PWD="${mysql_password}"
      taito::executing_start
      mysqldump -h "${database_host}" -P "${database_port}" \
        -u "${mysql_username}" "${database_name}"
    )
  else
    taito::executing_start
    mysqldump -p -h "${database_host}" -P "${database_port}" \
      -u "${mysql_username}" "${database_name}"
  fi
}

#!/bin/bash

function mysql::print_ssl_options () {
  if (
       [[ ${taito_command_requires_db_proxy:-} == "false" ]] &&
       [[ ${database_ssl_enabled:-} == "false" ]]
     ) || (
       [[ ${taito_command_requires_db_proxy:-} == "true" ]] &&
       [[ ${database_proxy_ssl_enabled:-} == "false" ]]
     ); then
    echo ""
  else
    taito::expose_db_ssl_credentials
    # NOTE: ssl-mode not supported by current version of MariaDB client:
    # https://github.com/volatiletech/sqlboiler/issues/273
    # echo -n "--ssl-mode=REQUIRED "
    echo -n "--ssl-ca=${database_ssl_ca_path} "
    echo -n "--ssl-cert=${database_ssl_cert_path} "
    echo -n "--ssl-key=${database_ssl_key_path}"
  fi
}

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

  local mysql_opts=""
  mysql_opts="$(mysql::print_ssl_options)"

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
    elif [[ ${database_app_username} ]] &&
       [[ ${database_app_password} ]] &&
       [[ ${mysql_password} == ${taito_default_password} ]]; then
      mysql_username="${database_app_username}"
      mysql_password="${database_app_password}"
    elif [[ ${database_build_username} ]]; then
      mysql_username="${database_build_username}"
      mysql_password="${database_build_password}"
    fi
  fi

  if [[ ${mysql_password:-} ]]; then
    (
      export MYSQL_PWD="${mysql_password}"
      taito::executing_start
      mysql ${mysql_opts} -h "${database_host}" -P "${database_port}" \
        -D "${database_name}" \
        -u "${mysql_username}"
    )
  else
    taito::executing_start
    mysql ${mysql_opts} -p -h "${database_host}" -P "${database_port}" \
      -D "${database_name}" \
      -u "${mysql_username}"
  fi
}

function mysql::dump () {
  local username="${1}"
  # flags="${2}"
  # command="${3:-mysql}"

  local mysql_username
  local mysql_password

  local mysql_opts=""
  mysql_opts="$(mysql::print_ssl_options)"

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
    elif [[ ${database_app_username} ]] &&
       [[ ${database_app_password} ]] &&
       [[ ${mysql_password} == ${taito_default_password} ]]; then
      mysql_username="${database_app_username}"
      mysql_password="${database_app_password}"
    fi
  fi

  if [[ ${mysql_password:-} ]]; then
    (
      export MYSQL_PWD="${mysql_password}"
      taito::executing_start
      mysqldump ${mysql_opts} -h "${database_host}" -P "${database_port}" \
        -u "${mysql_username}" "${database_name}"
    )
  else
    taito::executing_start
    mysqldump ${mysql_opts} -p -h "${database_host}" -P "${database_port}" \
      -u "${mysql_username}" "${database_name}"
  fi
}

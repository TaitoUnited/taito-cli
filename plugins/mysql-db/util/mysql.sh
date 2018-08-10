#!/bin/bash
: "${database_host:?}"
: "${database_port:?}"
: "${database_name:?}"

username="${1}"
# flags="${2}"
# command="${3:-mysql}"

# TODO: duplicate logic with mysqldump.sh and psql.sh
# TODO: needs refactoring

mysql_username="${database_name}a"
if [[ "${database_username:-}" ]]; then
  mysql_username="${database_username}"
fi
mysql_password="${database_password:-secret}"

if [[ "${username}" != "" ]]; then
  mysql_username="${username}"
  mysql_password=""
elif [[ "${taito_env}" != "local" ]]; then
  . "${taito_plugin_path}/util/mysql-username-password.sh"
  if [[ "${database_build_username}" ]] && \
     [[ "${database_build_password}" ]]; then
    mysql_username="${database_build_username}"
    mysql_password="${database_build_password}"
  fi
fi

if [[ "${mysql_password:-}" ]]; then
  MYSQL_PWD="${mysql_password}" \
  mysql -h "${database_host}" -P "${database_port}" -D "${database_name}" \
    -u "${mysql_username}"
else
  mysql -p -h "${database_host}" -P "${database_port}" -D "${database_name}" \
    -u "${mysql_username}"
fi

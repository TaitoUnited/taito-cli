#!/bin/bash
: "${database_host:?}"
: "${database_port:?}"
: "${database_name:?}"

username="${1:-$database_username}"

# TODO determine password from secrets

echo "host:${database_host} port:${database_port} database:${database_name} \
username:${username}"

if [[ "${database_password:-}" ]]; then
  MYSQL_PWD="${database_password}" \
  mysql -h "${database_host}" -P "${database_port}" -D "${database_name}" -u "${username}"
else
  mysql -p -h "${database_host}" -P "${database_port}" -D "${database_name}" -u "${username}"
fi

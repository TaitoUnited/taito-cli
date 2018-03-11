#!/bin/bash
: "${taito_vout:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_name:?}"

username="${1:-$database_username}"

# TODO determine password from secrets

if [[ "${database_password:-}" ]]; then
  MYSQL_PWD="${database_password}" \
  mysqldump -h "${database_host}" -P "${database_port}" -u "${username}" "${database_name}"
else
  mysqldump -p -h "${database_host}" -P "${database_port}" -u "${username}" "${database_name}"
fi

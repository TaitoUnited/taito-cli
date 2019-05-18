#!/bin/bash
: "${taito_vout:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_name:?}"

username="${1}"
# flags="${2}"
# command="${3:-mysql}"

mysql_username="${database_name}a"
if [[ "${database_username:-}" ]]; then
  mysql_username="${database_username}"
fi
mysql_password="${database_password:-$taito_default_password}"

if [[ "${username}" != "" ]]; then
  mysql_username="${username}"
  mysql_password=""
elif [[ "${taito_env}" != "local" ]]; then
  . "${taito_util_path}/database-username-password.sh"
  if [[ "${database_build_username}" ]] && \
     [[ "${database_build_password}" ]]; then
    mysql_username="${database_build_username}"
    mysql_password="${database_build_password}"
  fi
fi

if [[ "${database_password:-}" ]]; then
  (
    export MYSQL_PWD="${mysql_password}"
    ${taito_setv:?}
    mysqldump -h "${database_host}" -P "${database_port}" \
      -u "${mysql_username}" "${database_name}"
  )
else
  ${taito_setv:?}
  mysqldump -p -h "${database_host}" -P "${database_port}" \
    -u "${mysql_username}" "${database_name}"
fi

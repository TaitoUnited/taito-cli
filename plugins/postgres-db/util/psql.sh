#!/bin/bash

# TODO clean this mess. duplicate code in clean.sh, psql.sh and sqitch.sh

username="${1}"
flags="${2}"
command="${3:-psql}"

# TODO: duplicate logic with mysql.sh and mysqldump.sh
# TODO: needs refactoring

psql_username="${database_name}_app"
if [[ "${database_username:-}" ]]; then
  psql_username="${database_username}"
fi
psql_password="${database_password:-secret}"

if [[ "${username}" != "" ]]; then
  psql_username="${username}"
  psql_password=""
elif [[ "${taito_env}" != "local" ]]; then
  . "${taito_plugin_path}/util/postgres-username-password.sh"
  if [[ "${database_build_username}" ]] && \
     [[ "${database_build_password}" ]]; then
    psql_username="${database_build_username}"
    psql_password="${database_build_password}"
  fi
fi

(
  export PGPASSWORD="${psql_password}"
  ${taito_setv:?}
  ${command} -h "${database_host}" \
  -p "${database_port}" \
  -d "${database_name}" \
  -U "${psql_username}" \
  ${flags}
)

#!/bin/bash

# TODO clean this mess. duplicate code in clean.sh, psql.sh and sqitch.sh

username="${1}"
flags="${2}"
command="${3:-psql}"

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
  if [[ "${database_build_username}" ]]; then
    psql_username="${database_build_username}"
    psql_password="${database_build_password}"
  fi
fi

echo "Using username ${psql_username}"
(
  export PGPASSWORD="${psql_password}"
  ${taito_setv:?}
  ${command} -h "${database_host}" \
  -p "${database_port}" \
  -d "${database_name}" \
  -U "${psql_username}" \
  ${flags}
)

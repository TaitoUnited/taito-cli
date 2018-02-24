#!/bin/bash

username="${1}"
flags="${2}"
command="${3:-psql}"

if [[ "${username}" != "" ]]; then
  database_username="${username}"
  database_password=""
elif [[ "${taito_env}" == "local" ]]; then
  database_username="${database_name}_app"
  database_password="secret"
else
  . "${taito_plugin_path}/util/postgres-username-password.sh"
  database_username="${database_build_username}"
  database_password="${database_build_password}"
fi

echo "Using username ${database_username}"
(
  export PGPASSWORD="${database_password}"
  ${taito_setv:?}
  ${command} -h "${database_host}" \
  -p "${database_port}" \
  -d "${database_name}" \
  -U "${database_username}" \
  ${flags}
)

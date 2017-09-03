#!/bin/bash

username="${1}"
flags="${2}"
command="${3:-psql}"

if [[ "${username}" != "" ]]; then
  postgres_username="${username}"
  postgres_password=""
elif [[ "${taito_env}" == "local" ]]; then
  postgres_username="${postgres_database}_app"
  postgres_password="secret"
else
  . "${taito_plugin_path}/util/postgres-username-password.sh"
  postgres_username="${postgres_build_username}"
  postgres_password="${postgres_build_password}"
fi

echo "Using username ${postgres_username}"
PGPASSWORD="${postgres_password}" ${command} -h "${postgres_host}" \
  -p "${postgres_port}" \
  -d "${postgres_database}" \
  -U "${postgres_username}" \
  ${flags}

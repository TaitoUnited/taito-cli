#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

echo "- import users.sql"

. "${taito_plugin_path}/util/postgres-username-password.sh"

# Validate env variables

if [[ ${#postgres_build_password} -lt 20 ]]; then
  echo "ERROR: postgres_build_password too short or not set"
  exit 1
fi

if [[ ${#postgres_app_password} -lt 20 ]]; then
  echo "ERROR: postgres_build_password too short or not set"
  exit 1
fi

# Execute

psql -h "${postgres_host}" -p "${postgres_port}" \
  -U "${postgres_username}" \
  -f "${taito_plugin_path}/resources/users.sql" \
  -v "database=${postgres_database}" \
  -v "dbuserapp=${postgres_database}_app" \
  -v "passwordapp=${postgres_app_password}" \
  -v "passwordbuild=${postgres_build_password}"

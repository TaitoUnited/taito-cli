#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

echo "- import users.sql"

. "${taito_plugin_path}/util/postgres-username-password.sh"

# Validate env variables

if [[ ${#database_build_password} -lt 20 ]]; then
  echo "ERROR: database_build_password too short or not set"
  exit 1
fi

if [[ ${#database_app_password} -lt 20 ]]; then
  echo "ERROR: database_build_password too short or not set"
  exit 1
fi

# Execute

psql -h "${database_host}" -p "${database_port}" \
  -U "${database_username}" \
  -f "${taito_plugin_path}/resources/users.sql" \
  -v "database=${database_name}" \
  -v "dbuserapp=${database_name}_app" \
  -v "passwordapp=${database_app_password}" \
  -v "passwordbuild=${database_build_password}"

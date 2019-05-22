#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

. "${taito_util_path}/database-username-password.sh"

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

${taito_setv:?}
psql -h "${database_host}" -p "${database_port}" \
  -d postgres \
  -U "${database_username}" \
  -f "${taito_plugin_path}/resources/users.sql" \
  -v "database=${database_name}" \
  -v "dbusermaster=${database_master_username:-postgres}" \
  -v "dbuserapp=${database_name}_app" \
  -v "passwordapp=${database_app_password}" \
  -v "passwordbuild=${database_build_password}" \
  > ${taito_vout} 2>&1

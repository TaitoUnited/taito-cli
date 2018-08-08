#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

. "${taito_plugin_path}/util/mysql-username-password.sh"

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
mysql -h "${database_host}" \
  -P "${database_port}" \
  -u "${database_username}" \
  -e "set @database='${database_name}'; set @dbusermgr='${database_name}'; set @dbuserapp='${database_name}a'; set @passwordapp='${database_app_password}'; set @passwordmgr='${database_build_password}'; source ${taito_plugin_path}/resources/users.sql ;"

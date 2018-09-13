#!/bin/bash

# Reads mysql usernames and passwords to environment variables.
# TODO this is duplicate with postgres-username-password.sh

database_app_username="${database_name}a"
find_secret_name="db.${database_name}.app"
# TODO remove if
if [[ ${taito_secrets_version} == "2" ]]; then
  find_secret_name="${database_name}-db-app.password"
fi
. "${taito_cli_path}/util/secret-by-name.sh"
database_app_password="${secret_value}"
database_app_password_changed="${secret_changed}"

database_build_username="${database_name}"
find_secret_name="db.${database_name}.build"
# TODO remove if
if [[ ${taito_secrets_version} == "2" ]]; then
  find_secret_name="${database_name}-db-mgr.password"
fi
. "${taito_cli_path}/util/secret-by-name.sh"
database_build_password="${secret_value}"
database_build_password_changed="${secret_changed}"

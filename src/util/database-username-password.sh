#!/bin/bash

# Reads postgres usernames and passwords to environment variables.

database_app_username="${database_app_username:-${database_name}_app}"
find_secret_name="db.${database_name}.app"
# TODO remove if
if [[ ${taito_version:-} -ge "1" ]]; then
  find_secret_name="${database_app_secret:-${database_name}-db-app.password}"
fi
. "${taito_cli_path}/util/secret-by-name.sh"
database_app_password="${secret_value}"
database_app_password_changed="${secret_changed}"

database_build_username="${database_mgr_username:-${database_name}}"
find_secret_name="db.${database_name}.build"
# TODO remove if
if [[ ${taito_version:-} -ge "1" ]]; then
  find_secret_name="${database_mgr_secret:-${database_name}-db-mgr.password}"
fi
. "${taito_cli_path}/util/secret-by-name.sh"
database_build_password="${secret_value}"
database_build_password_changed="${secret_changed}"

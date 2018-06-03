#!/bin/bash

# Reads mysql usernames and passwords to environment variables.
# TODO this is duplicate with postgres-username-password.sh

database_app_username="${database_name}a"
find_secret_name="db.${database_name}.app"
. "${taito_cli_path}/util/secret-by-name.sh"
database_app_password="${secret_value}"

database_build_username="${database_name}"
find_secret_name="db.${database_name}.build"
. "${taito_cli_path}/util/secret-by-name.sh"
database_build_password="${secret_value}"

#!/bin/bash

# Reads postgres usernames and passwords to environment variables.

database_app_username="${database_name}_app"
find_secret_name="db.${database_name}.app"
. "${taito_cli_path}/util/secret-by-name.sh"
database_app_password="${secret_value}"

database_build_username="${database_name}"
find_secret_name="db.${database_name}.build"
. "${taito_cli_path}/util/secret-by-name.sh"
database_build_password="${secret_value}"

#!/bin/bash

# Reads postgres usernames and passwords to environment variables.

postgres_app_username="${postgres_database}_app"
find_secret_name="db.${postgres_database}.app"
. "${taito_cli_path}/util/secret-by-name.sh"
postgres_app_password="${secret_value}"

postgres_build_username="${postgres_database}"
find_secret_name="db.${postgres_database}.build"
. "${taito_cli_path}/util/secret-by-name.sh"
postgres_build_password="${secret_value}"

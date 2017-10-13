#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
# TODO rename postgres variables to common?
: "${postgres_external_port:?}"
: "${postgres_database:?}"

echo
echo "### docker - db-open: Displaying database info ###"
echo
echo "NOTE: Use the following connection details if you want to connect the"
echo "database with a database client GUI:"
echo "- host: 127.0.0.1"
echo "- port: ${postgres_external_port}"
echo "- database: ${postgres_database}"
echo "- username: ${postgres_database}_app"
echo "- password: secret"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

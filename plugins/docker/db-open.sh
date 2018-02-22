#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
# TODO rename postgres variables to common?
: "${database_external_port:?}"
: "${database_name:?}"

echo "NOTE: Use the following connection details if you want to connect the"
echo "database with a database client GUI:"
echo "- host: 127.0.0.1"
echo "- port: ${database_external_port}"
echo "- database: ${database_name}"
echo "- username: ${database_name}_app"
echo "- password: secret"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

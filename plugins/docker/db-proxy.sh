#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
# TODO rename postgres variables to common?
: "${postgres_external_port:?}"
: "${postgres_database:?}"

echo
echo "### docker - db-proxy: Displaying database info ###"
echo
echo "No database proxy required. Just connect with the following details:"
echo "- host: 127.0.0.1"
echo "- port: ${postgres_external_port}"
echo "- database: ${postgres_database}"
echo "- username: ${postgres_database}_app"
echo "- password: secret"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

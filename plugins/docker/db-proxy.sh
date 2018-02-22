#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
# TODO rename postgres variables to common?
: "${database_external_port:?}"
: "${database_name:?}"

echo "No database proxy required. Just connect with the following details:"
echo "- host: 127.0.0.1"
echo "- port: ${database_external_port}"
echo "- database: ${database_name}"
echo "- username: ${database_name}_app"
echo "- password: secret"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

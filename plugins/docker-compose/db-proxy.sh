#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_external_port:?}"
: "${database_name:?}"

echo "No database proxy required. Just connect with the following details:"
echo "- host: 127.0.0.1"
echo "- port: ${database_external_port:-database_port}"
echo "- database: ${database_name:-}"
echo "- username: ${database_username:-}, ${database_name}, ${database_name}_app, ${database_name}a"
echo "- password: ${database_password:-?}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

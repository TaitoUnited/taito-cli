#!/bin/bash
: "${taito_util_path:?}"
: "${database_name:?}"

echo "Database connection details:"
echo "- host: 127.0.0.1"
echo "- port: ${database_external_port:-database_port}"
echo "- database: ${database_name:-}"
echo "- username: ${database_username:-}, ${database_name}, ${database_name}_app, ${database_name}ap or your personal username"
echo "- password: ${database_password:-?}"

echo "TODO implement"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

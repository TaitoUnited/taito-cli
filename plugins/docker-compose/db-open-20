#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_external_port:?}"
: "${database_name:?}"

username="${database_name}_app"
if [[ "${database_type:-}" == "mysql" ]]; then
  username="${database_name}ap"
fi
if [[ "${database_username:-}" ]]; then
  username="${database_username}"
fi

echo "NOTE: You can use the following connection details if you want to connect the"
echo "database with a database client app:"
echo "- host: 127.0.0.1"
echo "- port: ${database_external_port}"
echo "- database: ${database_name}"
echo "- username: ${username}"
echo "- password: ${database_password:-$taito_default_password}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

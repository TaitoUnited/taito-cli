#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

username="${1}"

# TODO determine username automatically if not given
if [[ ! "${username}" ]]; then
  username="${database_name}_app"
fi

echo "host:${database_host} port:${database_port} database:${database_name} username:${username}"

# TODO determine password from secrets
MYSQL_PWD="secret" mysql -u "${username}" -h "${database_host}" -P "${database_port}" -D "${database_name}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

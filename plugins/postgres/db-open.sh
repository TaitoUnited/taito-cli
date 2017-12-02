#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${postgres_database:?}"
: "${postgres_host:?}"
: "${postgres_port:?}"

username="${1}"

echo "host: ${postgres_host} port:${postgres_port}"

"${taito_plugin_path}/util/psql.sh" "${username}" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

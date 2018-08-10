#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"
: "${database_username:?}"

${taito_setv:?}
psql -h "${database_host}" \
  -p "${database_port}" \
  -U "${database_username}" \
  -f "${taito_plugin_path}/resources/drop-users.sql" \
  -v "database=${database_name}" \
  -v "dbuserapp=${database_name}_app" > ${taito_vout}

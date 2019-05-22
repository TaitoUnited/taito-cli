#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"
: "${database_name:?}"
: "${database_host:?}"
: "${database_port:?}"

${taito_setv:?}
psql -h "${database_host}" \
  -p "${database_port}" \
  -d postgres \
  -U "${database_username}" \
  -f "${taito_plugin_path}/resources/drop.sql" \
  -v "database=${database_name}" \
  -v "databaseold=${database_name}_old" > ${taito_vout} 2>&1

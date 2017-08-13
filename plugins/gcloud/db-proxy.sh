#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${gcloud_project:?}"
: "${gcloud_zone:?}"
: "${gcloud_sql_proxy_port:?}"
# TODO rename postgres variables to common?
: "${postgres_database:?}"

echo
echo "### gcloud - db-proxy: Starting db proxy ###"
echo

echo "host=127.0.0.1, port=${gcloud_sql_proxy_port}"
echo
echo "Connect using your personal user account or"
echo "${postgres_database} as username"

if ! "${taito_plugin_path}/util/db-proxy-start.sh"; then
  exit 1
fi

if ! "${taito_plugin_path}/util/db-proxy-stop.sh"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

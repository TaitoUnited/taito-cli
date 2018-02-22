#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${gcloud_project:?}"
: "${gcloud_zone:?}"
: "${gcloud_sql_proxy_port:?}"
# TODO rename postgres variables to common?
: "${database_name:?}"

echo "host=127.0.0.1, port=${gcloud_sql_proxy_port}"
echo "Connect using your personal user account or"
echo "${database_name} as username"

"${taito_plugin_path}/util/db-proxy-start.sh" && \
"${taito_plugin_path}/util/db-proxy-stop.sh" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

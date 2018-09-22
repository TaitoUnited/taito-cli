#!/bin/bash -e

echo "- target: ${taito_target}"
echo "- env: ${taito_env}"
echo "- instance: ${database_instance}"
echo "- name: ${database_name}"
echo "- host: ${database_host}"
echo "- port: ${database_port}"
echo "- proxy port: ${database_proxy_port}"
echo "- passed env variable value: ${db_variable_value}"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

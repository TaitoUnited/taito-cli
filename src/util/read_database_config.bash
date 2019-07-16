#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

all_databases=$(taito::print_targets_of_type database)

target="${1}"
if [[ -z ${1} ]] && [[ -n "${taito_target:-}" ]] && \
   [[ "${all_databases:-}" == *"${taito_target}"* ]]; then
  target="${taito_target:-}"
fi
target="${target:-database}"

echo "Determining database settings by ${target}" > "${taito_dout:-/dev/null}"

env_var_name="db_${target}_name"
if [[ -n "${target}" ]] && [[ -n "${!env_var_name}" ]]; then
  env_var_name="db_${target}_instance"
  export database_instance="${!env_var_name}"
  echo "- database_instance: ${database_instance}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_type"
  export database_type="${!env_var_name}"
  echo "- database_type: ${database_type}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_name"
  export database_name="${!env_var_name}"
  echo "- database_name: ${database_name}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_host"
  export database_host="${!env_var_name}"
  echo "- database_host: ${database_host}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_real_host"
  export database_real_host="${!env_var_name}"
  echo "- database_real_host: ${database_real_host}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_real_port"
  export database_real_port="${!env_var_name}"
  echo "- database_real_port: ${database_real_port}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_proxy_host"
  export database_proxy_host="${!env_var_name}"
  echo "- database_proxy_host: ${database_proxy_host}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_proxy_port"
  export database_proxy_port="${!env_var_name}"
  echo "- database_proxy_port: ${database_proxy_port}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_port"
  export database_port="${!env_var_name}"
  echo "- database_port: ${database_port}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_external_port"
  export database_external_port="${!env_var_name}"
  echo "- database_external_port: ${database_external_port}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_master_username"
  export database_master_username="${!env_var_name}"
  echo "- database_master_username: ${database_master_username}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_master_password_hint"
  export database_master_password_hint="${!env_var_name}"
  echo "- database_master_password_hint: ${database_master_password_hint}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_username"
  export database_username="${!env_var_name}"
  echo "- database_username: ${database_username}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_password"
  export database_password="${!env_var_name}"
  echo "- database_password: ${database_password}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_app_username"
  export database_app_username="${!env_var_name}"
  echo "- database_app_username: ${database_app_username}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_app_secret"
  export database_app_secret="${!env_var_name}"
  echo "- database_app_secret: ${database_app_secret}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_mgr_username"
  export database_mgr_username="${!env_var_name}"
  echo "- database_mgr_username: ${database_mgr_username}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_mgr_secret"
  export database_mgr_secret="${!env_var_name}"
  echo "- database_mgr_secret: ${database_mgr_secret}" > "${taito_dout:-/dev/null}"

fi

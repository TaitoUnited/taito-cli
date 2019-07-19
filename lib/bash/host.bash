#!/bin/bash
# NOTE: This bash script is run also directly on host. Keep it macOS compatible.

function taito::confirm () {
  local text=${1:-Do you want to continue?}
  local default_reply=${2:-yes}
  local default_ci=$1
  local prompt
  local REPLY

  if [[ $taito_mode == "ci" ]] && [[ $default_ci == "yes" ]]; then
    return 0
  elif [[ $taito_mode == "ci" ]] && [[ $default_ci == "no" ]]; then
    return 130
  fi

  if [[ $default_reply == "yes" ]]; then
    prompt="$text [Y/n] "
  else
    prompt="$text [y/N] "
  fi

  # Flush input buffer
  read -r -t 1 -n 1000 || :

  # Display confirm prompt
  read -p "$prompt" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || ( \
       [[ $default_reply == "yes" ]] && \
       [[ $REPLY =~ ^[Yy]*$ ]] \
     ); then
    return 0
  else
    return 130
  fi
}

function taito::export_database_config () {
  # TODO: add support for print
  # local print_config=${1:-false}

  all_databases=$(taito::print_targets_of_type database)

  target="${1}"
  if [[ -z ${1} ]] && [[ ${taito_target:-} ]] && \
     [[ ${all_databases:-} == *"${taito_target}"* ]]; then
    target="${taito_target:-}"
  fi
  target="${target:-database}"

  echo "Determining database settings by ${target}" > "${taito_dout:-/dev/null}"

  env_var_name="db_${target}_name"
  if [[ ${target} ]] && [[ ${!env_var_name} ]]; then
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
}

function taito::print_targets_of_type () {
  local target_type=$1
  local targets
  local type_variable_name

  targets=""
  for target in ${taito_targets:-}
  do
    type_variable_name="taito_target_type_$target"
    if [[ ${!type_variable_name} == "$target_type" ]] || ( \
         [[ ! ${!type_variable_name} ]] && \
         [[ $target_type == "container" ]] \
       ); then
      targets="$targets $target"
    fi
  done

  echo "$targets"
}

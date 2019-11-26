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

    env_var_name="db_${target}_username_suffix"
    export database_username_suffix="${!env_var_name}"
    echo "- database_username_suffix: ${database_username_suffix}" > "${taito_dout:-/dev/null}"

    env_var_name="db_${target}_host"
    export database_host="${!env_var_name}"
    echo "- database_host: ${database_host}" > "${taito_dout:-/dev/null}"

    env_var_name="db_${target}_real_host"
    export database_real_host="${!env_var_name}"
    echo "- database_real_host: ${database_real_host}" > "${taito_dout:-/dev/null}"

    env_var_name="db_${target}_real_port"
    export database_real_port="${!env_var_name}"
    echo "- database_real_port: ${database_real_port}" > "${taito_dout:-/dev/null}"

    # TODO: is database_proxy_host used anywhere?
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

    env_var_name="db_${target}_ssl_enabled"
    export database_ssl_enabled="${!env_var_name:-true}"
    echo "- database_ssl_enabled: ${database_ssl_enabled}" > "${taito_dout:-/dev/null}"

    env_var_name="db_${target}_proxy_ssl_enabled"
    export database_proxy_ssl_enabled="${!env_var_name:-true}"
    echo "- database_proxy_ssl_enabled: ${database_proxy_ssl_enabled}" > "${taito_dout:-/dev/null}"

    env_var_name="db_${target}_master_username"
    export database_master_username="${!env_var_name}"
    echo "- database_master_username: ${database_master_username}" > "${taito_dout:-/dev/null}"

    env_var_name="db_${target}_master_password_hint"
    export database_master_password_hint="${!env_var_name}"
    echo "- database_master_password_hint: ${database_master_password_hint}" > "${taito_dout:-/dev/null}"

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

    export database_master_username_internal="${database_master_username%@*}"
    export database_app_username_internal="${database_app_username%@*}"
    export database_mgr_username_internal="${database_mgr_username%@*}"

    # TODO: remove?
    env_var_name="db_${target}_username"
    export database_username="${!env_var_name}"
    echo "- database_username: ${database_username}" > "${taito_dout:-/dev/null}"

    # TODO: remove?
    env_var_name="db_${target}_username_internal"
    export database_username_internal="${!env_var_name:-$database_username}"
    echo "- database_username_internal: ${database_username_internal}" > "${taito_dout:-/dev/null}"

    # TODO: remove?
    env_var_name="db_${target}_password"
    export database_password="${!env_var_name}"
    echo "- database_password: ${database_password}" > "${taito_dout:-/dev/null}"

    # TODO: remove?
    env_var_name="db_${target}_build_username"
    export database_build_username="${!env_var_name}"
    echo "- database_build_username: ${database_build_username}" > "${taito_dout:-/dev/null}"

    # TODO: remove?
    env_var_name="db_${target}_build_username_internal"
    export database_build_username_internal="${!env_var_name:-$database_build_username}"
    echo "- database_build_username_internal: ${database_build_username_internal}" > "${ttaito_dout:-/dev/null}"

    if [[ ${taito_command_requires_db_proxy:-} == "false" ]]; then
      echo "db proxy disabled -> use real host and port" > "${taito_dout:-/dev/null}"
      export database_host="${database_real_host:-$database_host}"
      export database_port="${database_real_port:-$database_port}"
      echo "- database_host: ${database_host}" > "${taito_dout:-/dev/null}"
      echo "- database_port: ${database_port}" > "${taito_dout:-/dev/null}"
    fi
  fi
}

function taito::export_storage_config () {
  # TODO: add support for print
  # local print_config=${1:-false}

  all_storages=$(taito::print_targets_of_type storage)
  target="${1}"
  if [[ -z ${1} ]] && [[ ${taito_target:-} ]] && \
     [[ ${all_storages:-} == *"${taito_target}"* ]]; then
    target="${taito_target:-}"
  fi
  target="${target:-storage}"
  echo "Determining storage settings by ${target}" > "${taito_dout:-/dev/null}"

  env_var_name="st_${target}_name"
  if [[ ${target} ]] && [[ ${!env_var_name} ]]; then
    env_var_name="st_${target}_name"
    export storage_name="${!env_var_name}"
    echo "- storage_name: ${storage_name}" > "${taito_dout:-/dev/null}"

    env_var_name="st_${target}_class"
    export storage_class="${!env_var_name}"
    echo "- storage_class: ${storage_class}" > "${taito_dout:-/dev/null}"

    env_var_name="st_${target}_location"
    export storage_location="${!env_var_name}"
    echo "- storage_location: ${storage_location}" > "${taito_dout:-/dev/null}"

    env_var_name="st_${target}_days"
    export storage_days="${!env_var_name}"
    echo "- storage_days: ${storage_days}" > "${taito_dout:-/dev/null}"

    env_var_name="st_${target}_backup_location"
    export storage_backup_location="${!env_var_name}"
    echo "- storage_backup_location: ${storage_backup_location}" > "${taito_dout:-/dev/null}"

    env_var_name="st_${target}_backup_days"
    export storage_backup_days="${!env_var_name}"
    echo "- storage_backup_days: ${storage_backup_days}" > "${taito_dout:-/dev/null}"
  fi
}

function taito::export_storage_attributes () {
  if [[ ${taito_storages} ]]; then
    # project taito-config.sh has already defined taito_storages
    return
  fi

  # Storage definitions for Terraform
  export taito_storages=
  export taito_storage_classes=
  export taito_storage_locations=
  export taito_storage_days=
  export taito_backup_locations=
  export taito_backup_days=

  all_storages=$(taito::print_targets_of_type storage)
  for target in ${all_storages}
  do
    env_var_name="st_${target}_name"
    taito_storages="${taito_storages} ${!env_var_name}"
    env_var_name="st_${target}_class"
    taito_storage_classes="${taito_storage_classes} ${!env_var_name}"
    env_var_name="st_${target}_location"
    taito_storage_locations="${taito_storage_locations} ${!env_var_name}"
    env_var_name="st_${target}_days"
    taito_storage_days="${taito_storage_days} ${!env_var_name}"
    env_var_name="st_${target}_backup_location"
    taito_backup_locations="${taito_backup_locations} ${!env_var_name}"
    env_var_name="st_${target}_backup_days"
    taito_backup_days="${taito_backup_days} ${!env_var_name}"
  done

  # Trim whitespace
  taito_storages=$(echo "${taito_storages}" | xargs)
  taito_storage_classes=$(echo "${taito_storage_classes}" | xargs)
  taito_storage_locations=$(echo "${taito_storage_locations}" | xargs)
  taito_storage_days=$(echo "${taito_storage_days}" | xargs)
  taito_backup_locations=$(echo "${taito_backup_locations}" | xargs)
  taito_backup_days=$(echo "${taito_backup_days}" | xargs)
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

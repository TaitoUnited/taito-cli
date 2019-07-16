#!/bin/bash

taito::expose_db_user_credentials () {
  local print_creds=${1:-false}

  database_app_username="${database_app_username:-${database_name}_app}"
  find_secret_name="db.${database_name}.app"
  # TODO remove if
  if [[ ${taito_version:-} -ge "1" ]]; then
    find_secret_name="${database_app_secret:-${database_name}-db-app.password}"
  fi
  taito::expose_secret_by_name
  database_app_password="${secret_value}"
  database_app_password_changed="${secret_changed}"

  database_build_username="${database_mgr_username:-${database_name}}"
  find_secret_name="db.${database_name}.build"
  # TODO remove if
  if [[ ${taito_version:-} -ge "1" ]]; then
    find_secret_name="${database_mgr_secret:-${database_name}-db-mgr.password}"
  fi
  taito::expose_secret_by_name
  database_build_password="${secret_value}"
  database_build_password_changed="${secret_changed}"

  if [[ ${taito_target_env} != "local" ]] && \
     [[ ! $database_app_password ]] && \
     [[ ! $database_build_password ]] && \
     [[ ${taito_quiet:-} != true ]] && \
     [[ ${print_creds:-} != true ]]; then
    echo -e "${NOTEs}" > /dev/stderr
    echo "WARNING: Failed to determine database passwords. If you have not been" > /dev/stderr
    echo "authenticated, run taito 'auth:${taito_target_env}' and try again." > /dev/stderr
    echo -e "${NOTEe}" > /dev/stderr
  fi

  if [[ ${print_creds:-} == true ]]; then
    echo "app_username=${database_app_username}"
    echo "app_password=${database_app_password}"
    echo "app_password_changed=${database_app_password_changed}"
    echo "mgr_username=${database_build_username}"
    echo "mgr_password=${database_build_password}"
    echo "mgr_password_changed=${database_build_password_changed}"
  fi
}
export -f taito::expose_db_user_credentials

# Reads secret info to environment variables. The secret in question is
# determined by the given ${secret_index}"
taito::expose_secret_by_index () {
  local secret_index=${1:-$secret_index} # TODO: remove $secret_index

  # TODO: refactor
  secret_namespace_var="secret_namespace_${secret_index}"
  secret_namespace=${!secret_namespace_var}

  secret_name_var="secret_name_${secret_index}"
  secret_name=${!secret_name_var}

  secret_value_var="secret_value_${secret_index}"
  secret_value=${!secret_value_var}
  secret_value_var2="secret_value_${secret_name//[-.]/_}"

  secret_default_value_var="default_secret_value_${secret_index}"
  secret_default_value=${!secret_default_value_var}

  secret_method_var="secret_method_${secret_index}"
  secret_method=${!secret_method_var}

  secret_changed_var="secret_changed_${secret_index}"
  secret_changed=${!secret_changed_var}

  if [[ "${secret_method}" == *"/"* ]]; then
    secret_source_namespace="${secret_method##*/}"
  else
    secret_source_namespace="${secret_namespace}"
  fi
}
export -f taito::expose_secret_by_index

taito::expose_secret_by_name () {
  local find_secret_name=${1:-$find_secret_name} # TODO remove $find_secret_name
  local print_creds=${2:-false}

  local found_index=-1
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index
    if [[ "${secret_name}" == "${find_secret_name}" ]]; then
      found_index=${secret_index}
      break
    fi
    secret_index=$((${secret_index}+1))
  done

  if [[ "${found_index}" != "-1" ]]; then
    secret_index=${found_index}
    taito::expose_secret_by_index
  fi

  if [[ ${print_creds} == true ]]; then
    echo "TODO print secret details"
  fi
}
export -f taito::expose_secret_by_name

taito::print_random_string () {
  local length=$1
  local value

  # TODO better tool for this?
  value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
  if [[ ${#value} -gt $length ]]; then
    value="${value: -$length}"
  fi
  echo "$value"
}
export -f taito::print_random_string

taito::print_random_words () {
  local num_of_words=$1

  cat /usr/share/dict/words | sort -R | head -n $num_of_words | \
    tr -dc '[:alnum:]\n\r' | tr '[:upper:]' '[:lower:]' | xargs echo | \
    tr ' ' '-'
}
export -f taito::print_random_words

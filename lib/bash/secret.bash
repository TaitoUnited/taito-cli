#!/bin/bash

function taito::expose_db_ssl_credentials () {
  taito::expose_secret_by_name "${database_instance}-db-ssl.ca"
  database_ssl_ca_path="${secret_value#secret_file:}"
  taito::expose_secret_by_name "${database_instance}-db-ssl.cert"
  database_ssl_cert_path="${secret_value#secret_file:}"
  taito::expose_secret_by_name "${database_instance}-db-ssl.key"
  database_ssl_key_path="${secret_value#secret_file:}"
}
export -f taito::expose_db_ssl_credentials

function taito::expose_db_user_credentials () {
  local print_creds=${1:-false}

  database_app_username="${database_app_username:-${database_name}_app}"
  find_secret_name="db.${database_name}.app"
  # TODO remove if
  if [[ ${taito_version:-} -ge "1" ]]; then
    find_secret_name="${database_app_secret:-${database_name}-db-app.password}"
  fi
  taito::expose_secret_by_name "${find_secret_name}"
  database_app_password="${secret_value}"
  database_app_password_changed="${secret_changed}"

  database_build_username="${database_mgr_username:-${database_name}}"
  find_secret_name="db.${database_name}.build"
  # TODO remove if
  if [[ ${taito_version:-} -ge "1" ]]; then
    find_secret_name="${database_mgr_secret:-${database_name}-db-mgr.password}"
  fi
  taito::expose_secret_by_name "${find_secret_name}"
  database_build_password="${secret_value}"
  database_build_password_changed="${secret_changed}"

  if [[ ${database_viewer_username} ]]; then
    database_viewer_username="${database_viewer_username}"
    find_secret_name="${database_viewer_secret:?}"
    taito::expose_secret_by_name "${find_secret_name}"
    database_viewer_password="${secret_value}"
    database_viewer_password_changed="${secret_changed}"
  fi

  if [[ ${database_default_username} ]]; then
    database_default_username="${database_default_username}"
    find_secret_name="${database_default_secret:?}"
    taito::expose_secret_by_name "${find_secret_name}"
    database_default_password="${secret_value}"
    # database_default_password_changed="${secret_changed}"
  fi

  if [[ ${taito_target_env} != "local" ]] && \
     [[ ! $database_app_password ]] && \
     [[ ! $database_build_password ]] && \
     [[ ! $database_viewer_password ]] && \
     [[ ! $database_default_password ]] && \
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
    echo "viewer_username=${database_viewer_username}"
    echo "viewer_password=${database_viewer_password}"
    echo "viewer_password_changed=${database_viewer_password_changed}"
    echo "default_username=${database_default_username}"
    echo "default_password=${database_default_password}"
    # echo "default_password_changed=${database_default_password_changed}"
  fi
}
export -f taito::expose_db_user_credentials

function taito::get_secret_value_format () {
  if [[ $1 == "random"* ]] ||
     [[ $1 == "manual"* ]] ||
     [[ ! $1 ]]
  then
    echo "literal"
  else
    echo "file"
  fi
}
export -f taito::get_secret_value_format

function taito::get_secret_hint () {
  local secret_name=$1

  # Filter taito_secret_hints the ones that match with secret name
  while IFS='*' read -ra items; do
    local trimmed=$(echo "${items[@]}" | awk '{$1=$1;print}')
    local name="${trimmed%=*}"
    local text="${trimmed##*=}"
    if [[ -n ${name} ]] && [[ ${secret_name} == *"${name}"* ]]; then
      echo "${text}"
    fi
  done <<< "${taito_global_secret_hints:-} ${taito_secret_hints:-}"
}
export -f taito::get_secret_hint

# Reads secret info to environment variables. The secret in question is
# determined by the given ${secret_index}"
function taito::expose_secret_by_index () {
  local secret_index=${1}

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
  secret_method_var2="secret_method_${secret_name//[-.]/_}"

  secret_orig_method_var="secret_orig_method_${secret_index}"
  secret_orig_method=${!secret_orig_method_var}
  secret_orig_method_var2="secret_orig_method_${secret_name//[-.]/_}"
  secret_orig_method=${secret_orig_method:-$secret_method}

  secret_value_format=$(taito::get_secret_value_format "${secret_method}")
  if [[ ${secret_value_format} == "file" ]]; then
    # if [[ ${secret_value} == "secret_file:"* ]]; then
    secret_filename=${secret_value#secret_file:}
  else
    secret_filename=""
  fi

  secret_changed_var="secret_changed_${secret_index}"
  secret_changed=${!secret_changed_var}

  if [[ ${secret_orig_method} == *"/"* ]]; then
    secret_source_namespace="${secret_orig_method##*/}"
  else
    secret_source_namespace="${secret_namespace}"
  fi
}
export -f taito::expose_secret_by_index

function taito::expose_secret_by_name () {
  local find_secret_name=${1}
  local print_creds=${2:-false}

  local found_index=-1
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}
    if [[ ${secret_name} == "${find_secret_name}" ]]; then
      found_index=${secret_index}
      break
    fi
    secret_index=$((${secret_index}+1))
  done

  if [[ ${found_index} != "-1" ]]; then
    secret_index=${found_index}
    taito::expose_secret_by_index ${secret_index}
  fi

  if [[ ${print_creds} == true ]]; then
    echo "TODO print secret details"
  fi
}
export -f taito::expose_secret_by_name

function taito::validate_secret_values () {
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}
    if [[ ${secret_value:-} ]] && [[ ${#secret_value} -lt 8 ]] && \
       [[ ${secret_orig_method} != "copy/"* ]] && [[ ${secret_orig_method} != "read/"* ]]; then
      echo "ERROR: secret ${secret_namespace}/${secret_name} too short or not set"
      exit 1
    fi
    secret_index=$((${secret_index}+1))
  done
}
export -f taito::validate_secret_values

function taito::print_secret_values () {
  local save_to_disk=$1
  local show_files=$2
  local secret_filter=$3
  local taito_secrets_path="${taito_project_path:?}/tmp/secrets/taito-secrets"

  if [[ ${save_to_disk} == "true" ]]; then
    rm -f "${taito_secrets_path}" &> /dev/null || :
    mkdir -p "${taito_project_path}/tmp/secrets"
  fi

  secret_index=0
  secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    if [[ ${secret_filter} ]] && [[ ${secret_name} != *"${secret_filter}"* ]]; then
      secret_index=$((${secret_index}+1))
      continue
    fi
    taito::expose_secret_by_index ${secret_index}

    if [[ ${save_to_disk} == "true" ]]; then
      if [[ ${secret_value} ]]; then
        echo "export ${secret_value_var}=\"${secret_value}\"; " >> "${taito_secrets_path}"
      fi
    elif [[ ${secret_value} ]]; then
      if [[ ${taito_quiet} != "true" ]]; then
        echo "Secret ${secret_name}:"
      fi
      if [[ ${secret_method} == "htpasswd-plain"* ]]; then
        # Show base64 decoded value
        echo "${secret_value}" | base64 --decode | sed 's/{PLAIN}//'
      elif [[ ${secret_value_format} == "file" ]] && [[ ${show_files} == "true" ]]; then
        # Show base64 decoded value
        echo "${secret_value}" | base64 --decode
      elif [[ ${secret_value_format} == "file" ]] && [[ ${secret_value} ]]; then
        echo "FILE"
      else
        echo "${secret_value}"
      fi
      if [[ ${taito_quiet} != "true" ]]; then
        echo
      fi
    fi
    secret_index=$((${secret_index}+1))
  done
}
export -f taito::print_secret_values

function taito::print_random_string () {
  local length=$1
  pwgen -sB "${length}" 1
}
export -f taito::print_random_string

function taito::print_random_words () {
  local num_of_words=$1
  xkcdpass -n "${num_of_words}" -d "-"
}
export -f taito::print_random_words

function taito::print_random_uuid () {
  uuidgen
}
export -f taito::print_random_uuid

function taito::save_secrets () {
  local get_secret_func="${1}"
  local put_secret_func="${2}"
  local backup_mode="${3:-false}"

  local secret_value
  local secret_filename

  # TODO: why here? should be in generate secrets.
  taito::validate_secret_values

  # Save secret values
  secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    if [[ ${secret_changed:-} ]] && (
          [[ ${secret_value:-} ]] || (
            [[ ${secret_orig_method} == "copy/"* ]] &&
            [[ ${backup_mode} == "false" ]]
          )
       ); then

      # REFACTOR: move elsewhere?
      if [[ ${secret_name} == *"_"* ]]; then
        taito::print_note_start
        echo "WARNING: Secret name '${secret_name}' contains an underscore (_)."
        echo "It's best to avoid underscores in secret names."
        taito::print_note_end
      fi

      if [[ ${secret_orig_method} == "copy/"* ]]; then
        echo "Read secret ${secret_name} for copy" > "${taito_vout:-}"
        echo "-> ${get_secret_func} ${taito_zone:-} ${secret_source_namespace}" \
          "${secret_name}" > "${taito_vout:-}"
        secret_value=$(
          "${get_secret_func}" \
            "${taito_zone:-}" \
            "${secret_source_namespace}" \
            "${secret_name}"
        )
        if [[ ${secret_value_format} == "file" ]]; then
          mkdir -p "${taito_tmp_secrets_dir}"
          secret_filename="${taito_tmp_secrets_dir}/${secret_name}"
          echo "Save secret value to file ${secret_filename}" > "${taito_vout:-}"
          echo "${secret_value}" | base64 --decode > "${secret_filename}"
          secret_value="secret_file:${secret_filename}"
        fi
      fi

      if [[ ${secret_orig_method} != "read/"* ]]; then
        echo "Save secret ${secret_name}" > "${taito_vout:-}"
        if [[ ! ${secret_value} ]] || (
           [[ ${secret_value_format} == "file" ]] && [[ ! -f ${secret_filename} ]]
          ) ; then
          echo "WARNING! ${secret_name} value is empty" 1>&2
        fi
        "${put_secret_func}" \
          "${taito_zone:-}" \
          "${secret_namespace}" \
          "${secret_name}" \
          "${secret_method}" \
          "${secret_value}" \
          "${secret_filename}"
        # shellcheck disable=SC2181
        if [[ $? -gt 0 ]]; then
         exit 1
        fi
      fi
    fi
    secret_index=$((${secret_index}+1))
  done
}
export -f taito::save_secrets

function taito::export_secrets () {
  : "${taito_project_path:?}"
  : "${taito_env:?}"
  local get_secret_func=$1
  local save_to_disk=$2
  local filter=$3

  if [[ ${save_to_disk} == "true" ]]; then
    mkdir -p "${taito_tmp_secrets_dir}"
  fi

  # Get secret values
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    if [[ ${filter} ]] && [[ ${secret_name} != *"${filter}"* ]]; then
      secret_index=$((${secret_index}+1))
      continue
    fi

    local real_method="${secret_orig_method:-$secret_method}"
    if [[ ${real_method} == "copy/"* ]] || [[ ${real_method} == "read/"* ]]; then
      real_method=$(
        "${get_secret_func}" \
          "${taito_zone:-}" \
          "${secret_source_namespace}" \
          "${secret_name}.METHOD" \
          "manual"
      )
    fi

    if [[ ! ${real_method} ]]; then
      real_method="manual"
      if [[ ${secret_name} == *".key" ]] ||
         [[ ${secret_name} == *".cert" ]] ||
         [[ ${secret_name} == *".ca" ]]; then
        real_method="file"
      fi
      echo "WARNING: Secret method not set for ${secret_name}. Using '${real_method}' as method." 1>&2
      echo 1>&2
    fi

    local secret_value
    secret_value=$(
      "${get_secret_func}" \
        "${taito_zone:-}" \
        "${secret_source_namespace}" \
        "${secret_name}" \
        "${real_method}"
    )

    if [[ ${secret_value} ]]; then
      local secret_value_format
      secret_value_format=$(taito::get_secret_value_format "${real_method}")

      if [[ ${save_to_disk} == "true" ]]; then
        file="${taito_tmp_secrets_dir}/${secret_name}"

        if [[ ${taito_mode:-} == "ci" ]]; then
          echo "Saving secret to ${file}"
        else
          echo "Saving secret to ${file}" > "${taito_vout}"
        fi
        if [[ ${secret_value_format} == "file" ]]; then
          # Secret values of type 'file' are base64 encoded strings
          echo -n "${secret_value}" | base64 --decode > "${file}"
          # Replace secret value with a file path
          # TODO: save file path to a separate env var (secret_value should always be value)
          secret_value="secret_file:${file}"
        else
          echo -n "${secret_value}" > "${file}"
        fi
        chmod 0600 "${file}"
      fi

      set +x
      # shellcheck disable=SC2181
      if [[ $? -gt 0 ]]; then
        exit 1
      fi
      exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
      exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "
      exports="${exports}export ${secret_method_var}=\"${real_method}\"; "
      exports="${exports}export ${secret_method_var2}=\"${real_method}\"; "
      exports="${exports}export ${secret_orig_method_var}=\"${secret_method}\"; "
      exports="${exports}export ${secret_orig_method_var2}=\"${secret_method}\"; "
    fi

    secret_index=$((${secret_index}+1))
  done

  eval "$exports"
}
export -f taito::export_secrets

function taito::delete_secrets () {
  : "${taito_secret_names:?}"
  local delete_secret_func=$1

  local secret_name
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}
    if [[ ${secret_orig_method:?} != "read/"* ]]; then
      "${delete_secret_func}" \
        "${taito_zone:-}" \
        "${secret_namespace}" \
        "${secret_name}"
    fi
    secret_index=$((${secret_index}+1))
  done

  echo
}
export -f taito::delete_secrets

# TODO: remove taito_proxy_credentials_file (not used in latest full-stack-template)
function taito::save_proxy_secret_to_disk () {
  : "${taito_project_path:?}"
  local get_secret_func=$1

  export taito_proxy_credentials_file=/project/tmp/secrets/proxy_credentials.json
  export taito_proxy_credentials_local_file="$taito_project_path/tmp/secrets/proxy_credentials.json"

  local namespace=devops
  taito_proxy_secret_name=cicd-tester-serviceaccount
  taito_proxy_secret_key=key
  taito_proxy_secret_method="file"

  # TODO: remove
  if [[ ${taito_zone:-} == "gcloud-temp1" ]]; then
    taito_proxy_secret_name=gcp-proxy-gserviceaccount
    taito_proxy_secret_key=key
    taito_proxy_secret_method="file"
  fi

  local decode="cat"
  if [[ ${taito_proxy_secret_method} == "file" ]]; then
    decode="base64 --decode"
  fi

  if [[ $taito_proxy_secret_name ]]; then
    echo "Reading proxy secret (${namespace}/${taito_proxy_secret_name}.${taito_proxy_secret_key})"
    mkdir -p "$taito_project_path/tmp/secrets"

    "${get_secret_func}" \
      "${taito_zone:-}" \
      "${namespace}" \
      "${taito_proxy_secret_name}.${taito_proxy_secret_key}" \
      "${taito_proxy_secret_method}" \
          | ${decode} > "$taito_proxy_credentials_local_file" ||
        echo "WARNING: Failed to get the proxy secret from Kubernetes"

    if [[ ! -s "$taito_proxy_credentials_local_file" ]]; then
      echo "WARNING: Proxy secret not set (${namespace}/${taito_proxy_secret_name})"
    fi
  fi
}
export -f taito::save_proxy_secret_to_disk

function taito::expose_required_secrets_filter () {
  # Determine which secrets should be fetched from AWS
  # TODO: tighter secret filter for running tests
  # TODO: not always necessary to save to disk?
  fetch_secrets=false
  save_secrets_to_disk=false
  secret_purpose=
  secret_filter=
  if [[ ${taito_command_requires_secrets:-} == true ]] && \
     [[ $taito_secrets_retrieved != true ]]; then
    if [[ ${taito_command} == "build-prepare" ]] || \
       [[ ${taito_command} == "build-release" ]]; then
      fetch_secrets="true"
      save_secrets_to_disk="true"
      secret_purpose="version control release"
      # TODO: remove git.github.build and github-buildbot (backwards compatibility)
      if [[ ${taito_secret_names:-} == *"git.github.build"* ]]; then
        secret_filter="git.github.build"
      elif [[ ${taito_secret_names} == *"github-buildbot"* ]]; then
        secret_filter="github-buildbot"
      else
        secret_filter="version-control"
      fi
    elif [[ ${taito_commands_only_chain:-} == *"-db/"* ]] || \
         [[ ${taito_command} == "db-proxy" ]]; then
      fetch_secrets="true"
      save_secrets_to_disk="true"
      secret_purpose="database access"
      secret_filter="db"
    elif [[ ${taito_command} == "test" ]] &&
         [[ -f taito-testing-config.sh ]] &&
         [[ "stag canary prod" != *"${taito_env}"* ]]; then
      # TODO: remove (for backwards compatibility)
      fetch_secrets="true"
      save_secrets_to_disk="true"
      secret_purpose="test suites"
      secret_filter=
    fi
  fi
}
export -f taito::expose_required_secrets_filter

function taito::get_secret_name () {
  echo "${1//_/-}" | sed 's/\([^\.]*\).*/\1/'
}
export -f taito::get_secret_name

function taito::get_secret_property () {
  echo "${1//_/-}" | sed 's/[^\.]*\.\(.*\)/\1/'
}
export -f taito::get_secret_property

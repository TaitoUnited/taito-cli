#!/bin/bash

function docker-compose::get_secret_value () {
  : "${taito_project_path:?}"
  : "${taito_env:?}"
  local zone=$1
  local namespace=$2
  local name=$3
  local real_method=$4

  local secret_name
  local secret_property
  local format
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")
  format=$(taito::get_secret_value_format "${real_method}")

  local file
  local remote_file
  file="${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property}"
  if [[ ${taito_env} != "local" ]] && [[ ${taito_host:-} ]]; then
    remote_file="${taito_host_dir:?}/secrets/${taito_env}/${secret_name}.${secret_property:?}"
    taito::expose_ssh_opts
    ssh -t ${ssh_opts} "${taito_ssh_user:?}@${taito_host}" \
      "bash -c 'cat ${remote_file} 2> /dev/null'" 2> /dev/null > "${file}"
  fi

  if [[ -f ${file} ]]; then
    if [[ ${format} == file ]]; then
      base64 -i "${file}" 2> /dev/null || :
    else
      cat "${file}" 2> /dev/null || :
    fi
  fi
}

function docker-compose::put_secret_value () {
  : "${taito_project_path:?}"
  : "${taito_env:?}"
  local zone=$1
  local namespace=$2
  local name=$3
  local method=$4
  local value=$5
  local filename=$6

  local secret_name
  local secret_property
  local path_suffix
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")
  path_suffix="${taito_env}/${secret_name}.${secret_property}"

  mkdir -p "${taito_project_path}/secrets/${taito_env}"
  mkdir -p "${taito_project_path}/secrets/changed/${taito_env}"
  if [[ ${filename} ]]; then
    cp "${filename}" "${taito_project_path}/secrets/${path_suffix}"
    cp "${filename}" "${taito_project_path}/secrets/changed/${path_suffix}"
  else
    printf "%s" "${value}" > \
      "${taito_project_path}/secrets/${path_suffix}"
    printf "%s" "${value}" > \
      "${taito_project_path}/secrets/changed/${path_suffix}"
  fi
}

function docker-compose::delete_secret_value () {
  : "${taito_project_path:?}"
  : "${taito_env:?}"
  local zone=$1
  local namespace=$2
  local name=$3

  local secret_name
  local secret_property
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  rm -f "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}" || :
}

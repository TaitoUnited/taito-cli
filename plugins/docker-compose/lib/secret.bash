#!/bin/bash

function docker-compose::export_secrets () {
  # Read secret values from ./secrets
  local secret_name
  local secret_property
  local secret_value
  local file
  local remote_file

  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    # TODO remove once all project have been converted
    secret_property="SECRET"
    if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
      # TODO: ugly hack that currently occurs in 4 places
      secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    echo "+ reading ${secret_name} from " \
      "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}" > \
      "${taito_vout:?}"

    file="${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}"
    if [[ "${secret_method}" == "random" ]] || \
       [[ "${secret_method}" == "manual" ]] || ( \
         [[ "${secret_method}" == "htpasswd-plain" ]] && \
         [[ "${taito_env}" != "local" ]] \
      ); then
      if [[ "${taito_host:-}" ]] && \
         [[ "${taito_env}" != "local" ]]; then
         remote_file="${taito_host_dir:?}/secrets/${taito_env}/${secret_name}.${secret_property:?}"
         taito::expose_ssh_opts
         secret_value=$(ssh -t ${ssh_opts} "${taito_ssh_user:?}@${taito_host}" \
           "sudo -- bash -c 'cat ${remote_file} 2> /dev/null'" 2> /dev/null)
      else
        secret_value=$(cat "${file}" 2> /dev/null || :)
      fi
    elif [[ -f ${file} ]]; then
      secret_value="secret_file:${file}"
    fi

    if [[ ${secret_value} ]]; then
      exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
      exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "
    fi

    secret_index=$((${secret_index}+1))
  done

  eval "$exports"
}

function docker-compose::delete_secrets () {
  # Delete secret values from ./secrets
  local secret_name
  local secret_property

  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    # TODO remove once all project have been converted
    secret_property="SECRET"
    if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
      # TODO: ugly hack that currently occurs in 4 places
      secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    if [[ ${secret_method:?} != "read/"* ]]; then
      (
        taito::executing_start
        rm -f "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}" || :
      )
    fi
    secret_index=$((${secret_index}+1))
  done

  echo
}

function docker-compose::save_secrets () {
  rm -rf "${taito_project_path}/secrets/changed/${taito_env}"
  mkdir -p "${taito_project_path}/secrets/changed/${taito_env}"

  local secret_name
  local secret_property
  local secret_value
  local secret_changed

  # Save secret values to ./secrets
  mkdir -p "${taito_project_path}/secrets/${taito_env}"
  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in "${secret_names[@]}"
  do
    taito::expose_secret_by_index ${secret_index}

    if [[ "${secret_changed:-}" ]] && \
       [[ "${secret_value:-}" ]] && \
       [[ "${secret_method:-}" != "read/"* ]]; then

      # TODO remove once all projects have been converted
      secret_property="SECRET"
      if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
        # TODO: ugly hack that currently occurs in multiple places
        secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
        secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
      fi

      if [[ ${secret_value} == "secret_file:"* ]]; then
        yes | cp -f "${secret_value#secret_file:}" \
          "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}" \
          || echo "WARN: Failed to copy ${secret_value#secret_file:}"
        yes | cp -f "${secret_value#secret_file:}" \
          "${taito_project_path}/secrets/changed/${taito_env}/${secret_name}.${secret_property:?}" \
          || echo "WARN: Failed to copy ${secret_value#secret_file:}"
      else
        printf "%s" "${secret_value}" > \
          "${taito_project_path}/secrets/${taito_env}/${secret_name}.${secret_property:?}"
        printf "%s" "${secret_value}" > \
          "${taito_project_path}/secrets/changed/${taito_env}/${secret_name}.${secret_property:?}"
      fi
    fi
    secret_index=$((${secret_index}+1))
  done

  if [[ ${docker_compose_skip_restart:-} != "true" ]]; then
    echo
    echo "You may need to restart the containers to deploy the new secrets:"
    echo
    echo "taito restart:TARGET"
    echo "taito restart"
    echo
  fi
}

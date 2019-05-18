#!/bin/bash
: "${taito_project_path:?}"
: "${taito_env:?}"

# Read secret values from ./secrets
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

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
       . "${taito_cli_path}/plugins/ssh/util/opts.sh"
       secret_value=$(ssh -t ${opts} "${taito_ssh_user:?}@${taito_host}" \
         "sudo -- bash -c 'cat ${remote_file} 2> /dev/null'" 2> /dev/null)
    else
      secret_value=$(cat "${file}" 2> /dev/null)
    fi
  else
    secret_value="secret_file:${file}"
  fi

  exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
  exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "

  secret_index=$((${secret_index}+1))
done

eval "$exports"

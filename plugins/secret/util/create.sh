#!/bin/bash

exports=""
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  if [[ -z "${name_filter}" ]] || [[ ${secret_name} == *"${name_filter}"* ]]; then
    . "${taito_cli_path}/util/secret-by-index.sh"
    if [[ "${secret_method}" == "manual" ]]; then
      echo
      echo "New secret for ${secret_name}:"
      read -r -s secret_value
      echo "New secret for ${secret_name} again:"
      read -r -s secret_value2
      if [[ "${secret_value}" != "${secret_value2}" ]]; then
        echo "ERROR: Passwords do not match!"
        exit 1
      fi
    elif [[ "${secret_method}" == "random" ]]; then
      # TODO better tool for this?
      secret_value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
      echo "- ${secret_name}: random value generated"
    else
      echo "- skipping ${secret_name}. Method ${secret_method} not supported!"
    fi
    exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
  fi
  secret_index=$((${secret_index}+1))
done && \

eval "$exports"

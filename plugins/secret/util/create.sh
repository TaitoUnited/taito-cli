#!/bin/bash

exports=""
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  if [[ "${secret_method}" == "manual" ]]; then
    echo "New secret for ${secret_name}:"
    read -r -s secret_value
  elif [[ "${secret_method}" == "random" ]]; then
    # TODO better tool for this?
    secret_value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]/a/g')
    echo "- ${secret_name}: random value generated"
  else
    echo "- skipping ${secret_name}. Method ${secret_method} not supported!"
  fi
  exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
  secret_index=$((${secret_index}+1))
done && \

eval "$exports"

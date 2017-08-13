#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_customer:?}"
: "${taito_env:?}"

flag=${1}

echo
echo "### kubectl - secrets: Fetching secrets saved on Kubernetes ###"
echo

# Change namespace
"${taito_plugin_path}/util/use-context.sh"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/get-secrets.sh"

# Print secret values
echo
echo
rm taito-secrets.sh &> /dev/null
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ ${secret_method} != "copy/"* ]] && [[ ${secret_method} != "read/"* ]]; then
    if [[ "${flag}" == "--save-as-taito-secrets" ]]; then
      echo "export ${secret_value_var}=\"${secret_value}\"; " >> taito-secrets.sh
    else
      echo "Secret ${secret_name}:"
      echo "${secret_value}"
      echo
    fi
  fi
  secret_index=$((${secret_index}+1))
done

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

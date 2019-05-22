#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_namespace:?}"

flag=${1}

"${taito_cli_path}/plugins/kubectl/util/use-context.sh" && \

kubectl get secrets && \
echo && \

save_to_disk=false
if [[ "${flag}" == "--save-as-taito-secrets" ]]; then
  save_to_disk=true
fi

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/get-secrets.sh" "${save_to_disk}" && \

# Print secret values
echo 'Showing secret values from Kubernetes:' && \
echo && \
rm taito-secrets.sh &> /dev/null || : && \
secret_index=0 && \
secret_names=(${taito_secret_names}) && \
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret-by-index.sh" && \

  if [[ "${flag}" == "--save-as-taito-secrets" ]]; then
    echo "export ${secret_value_var}=\"${secret_value}\"; " >> taito-secrets.sh
  else
    echo "Secret ${secret_name}:"
    echo "${secret_value:-HIDDEN}"
    echo
  fi
  secret_index=$((${secret_index}+1))
done && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

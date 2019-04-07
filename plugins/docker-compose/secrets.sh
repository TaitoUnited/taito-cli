#!/bin/bash
: "${taito_util_path:?}"
: "${taito_project_path:?}"
: "${taito_setv:?}"

flag=${1}

echo "Secrets in docker-compose.yaml:"
(${taito_setv}; cat docker-compose.yaml | grep -i "SECRET\|PASSWORD\|KEY\|ID")
echo

if [[ -f ./taito-run-env.sh ]]; then
  echo "Secrets in taito-run-env.sh:"
  (${taito_setv}; cat ./taito-run-env.sh)
fi

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/get-secrets.sh" && \

# Print secret values
echo 'Showing in ./secrets:' && \
echo && \
rm taito-secrets.sh &> /dev/null || : && \
secret_index=0 && \
secret_names=(${taito_secret_names}) && \
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh" && \

  if [[ ${secret_method} != "copy/"* ]] && [[ ${secret_method} != "read/"* ]]; then
    if [[ "${flag}" == "--save-as-taito-secrets" ]]; then
      echo "export ${secret_value_var}=\"${secret_value}\"; " >> taito-secrets.sh
    else
      echo "Secret ${secret_name}:"
      echo "${secret_value}"
      echo
    fi
  fi && \
  secret_index=$((${secret_index}+1))
done && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

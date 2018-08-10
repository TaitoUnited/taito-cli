#!/bin/bash
: "${taito_cli_path:?}"

exports=""
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  if ( [[ -z "${name_filter}" ]] || [[ ${secret_name} == *"${name_filter}"* ]] ) && \
    "${taito_cli_path}/util/confirm-execution.sh" "${secret_name}" "" \
      "Create new value for secret '${secret_name}' with method '${secret_method:-}'"
  then
    secret_value=""
    secret_value2=""
    if [[ "${secret_method}" == "manual" ]]; then
      while [[ ${#secret_value} -lt 8 ]] || [[ "${secret_value}" != "${secret_value2}" ]]; do
        echo "New secret for ${secret_name} (min 8 characters):"
        read -r -s secret_value
        echo "New secret for ${secret_name} again:"
        read -r -s secret_value2
      done
    elif [[ "${secret_method}" == "file" ]]; then
      echo "Give file path for ${secret_name} relative to project root folder."
      if [[ "${secret_name}" == *"gcloud"* ]]; then
        echo "You most likely can download the secret key file from the following url:"
        echo "https://console.cloud.google.com/iam-admin/serviceaccounts?project=${taito_resource_namespace_id}"
        echo
      fi
      while [[ ! -f ${secret_value} ]]; do
        echo "File path (for example './secret.json'):"
        read -r secret_value
      done
    elif [[ "${secret_method}" == "random" ]]; then
      # TODO better tool for this?
      secret_value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
      if [[ ${#secret_value} -gt 30 ]]; then
        secret_value="${secret_value: -30}"
      fi
      echo "random value generated"
    fi
    echo
    exports="${exports}export ${secret_value_var}=\"${secret_value}\"; export ${secret_changed_var}=\"true\"; "
  fi
  secret_index=$((${secret_index}+1))
done && \

eval "$exports"

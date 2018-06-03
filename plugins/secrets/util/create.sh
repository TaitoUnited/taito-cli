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
      echo "New secret for ${secret_name} (min 8 characters):"
      read -r -s secret_value
      echo "New secret for ${secret_name} again:"
      read -r -s secret_value2
      if [[ "${secret_value}" != "${secret_value2}" ]]; then
        echo "ERROR: Passwords do not match!"
        exit 1
      fi
    elif [[ "${secret_method}" == "file" ]]; then
      echo "Secret ${secret_name}"
      echo
      if [[ "${secret_name}" == *"gcloud"* ]]; then
        echo "HINT: You most likely can download the secret key file from the following url:"
        echo "https://console.cloud.google.com/iam-admin/serviceaccounts?project=${gcloud_resource_project_id}"
      fi
      echo
      echo "File path for ${secret_name} relative to project root folder"
      echo "(for example './secret.json'):"
      read -r secret_value
      echo
      echo "REMEMBER TO DELETE THE FILE FROM LOCAL DISK AFTER THE EXECUTION OF" echo "THIS TAITO COMMAND HAS FINISHED! AND NEVER COMMIT IT TO GIT!"
      echo "PRESS ENTER TO CONTINUE"
      read -r
    elif [[ "${secret_method}" == "random" ]]; then
      # TODO better tool for this?
      secret_value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
      if [[ ${#secret_value} -gt 30 ]]; then
        secret_value="${secret_value: -30}"
      fi
      echo "- ${secret_name}: random value generated"
    fi
    exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
  fi
  secret_index=$((${secret_index}+1))
done && \

eval "$exports"

#!/bin/bash
: "${secret_method:?}"

secret_value=""
secret_value2=""

case "${secret_method}" in
  manual)
    while [[ ${#secret_value} -lt 8 ]] || [[ "${secret_value}" != "${secret_value2}" ]]; do
      echo "New secret for ${secret_name} (min 8 characters):"
      read -r -s secret_value
      echo "New secret for ${secret_name} again:"
      read -r -s secret_value2
    done
    ;;
  file)
    echo "Give file path for ${secret_name} relative to project root folder."
    if [[ "${secret_name}" == *"gcloud"* ]]; then
      echo "You most likely can download the secret key file from the following url:"
      echo "https://console.cloud.google.com/iam-admin/serviceaccounts?project=${taito_resource_namespace_id:-}"
      echo
    fi
    while [[ ! -f ${secret_value} ]]; do
      echo "File path (for example './secret.json'):"
      read -r secret_value
    done
    ;;
  htpasswd)
    mkdir -p ./tmp
    secret_value="./tmp/${secret_name}"
    rm -f "${secret_value}"
    touch "${secret_value}"
    echo "Enter all usernames and passwords for the htpasswd file."
    echo "Leave the username empty when you are done."
    while echo && echo "username: " && read -r username && [[ ${username} ]]
    do
      until htpasswd "${secret_value}" "${username}"; do :; done
    done
    echo
    echo "NOTE: Remember to save these usernames and passwords to a safe location."
    echo "Use a password manager for example. Press enter to continue."
    read -r
    ;;
  random)
    # TODO better tool for this?
    secret_value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
    if [[ ${#secret_value} -gt 30 ]]; then
      secret_value="${secret_value: -30}"
    fi
    echo "random value generated"
    ;;
  *)
    if [[ "${secret_method}" != "read/"* ]] && \
       [[ "${secret_method}" != "copy/"* ]]; then
      echo "ERROR: Unknown secret method: ${secret_method}"
      exit 1
    fi
    ;;
esac

echo
exports="${exports}export ${secret_value_var}=\"${secret_value}\"; export ${secret_changed_var}=\"true\"; "

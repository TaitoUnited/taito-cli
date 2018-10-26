#!/bin/bash
: "${secret_method:?}"
: "${taito_setv:?}"

set -e

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
      opts=""
      if [[ ${google_authuser:-} ]]; then
        opts="authuser=${google_authuser}&"
      fi
      echo "You most likely can download the secret key file from the following url:"
      echo "https://console.cloud.google.com/iam-admin/serviceaccounts?${opts}project=${taito_resource_namespace_id:-}"
      echo
    fi
    while [[ ! -f ${secret_value} ]]; do
      echo "File path (for example 'secret.json'):"
      read -r secret_value
    done
    ;;
  csrkey)
    while [[ ! "${domain}" ]]; do
      echo "Enter domain name (e.g. 'app.mydomain.com'):"
      read -r domain
    done
    echo "Next you'll have to enter details of the organization that owns the"
    echo "domain. You can usually leave the email and all the 'extra attributes'"
    echo "empty. Enter the domain name again when you are asked for a 'common name'."
    echo
    echo "If you are not sure of the details, try to find an existing website of the"
    echo "organization and use its certificate details as an example."
    echo
    echo "Press enter to continue"
    echo read -r
    mkdir -p ./tmp
    key_file="./tmp/${domain}.key"
    csr_file="./tmp/${domain}.csr"
    rm -f "${key_file}"
    rm -f "${csr_file}"
    (
      ${taito_setv}
      openssl req -new -newkey rsa:2048 -nodes \
        -keyout "${key_file}" -out "${csr_file}"
    )
    secret_value="${key_file}"
    echo
    echo "The generated secret key will be saved to Kubernetes and deleted from"
    echo "local disk during this command execution."
    echo
    echo "After this command has been executed successfully, you should send the"
    echo "generated '${csr_file}' file to the Certificate Authority. If someone"
    echo "else does that instead, it is ok to send the csr file to him by email."
    echo
    echo "Press enter to continue"
    echo read -r
    ;;
  htpasswd|htpasswd-plain)
    mkdir -p ./tmp
    secret_value="./tmp/${secret_name}"
    rm -f "${secret_value}"
    touch "${secret_value}"
    echo "Enter all usernames and passwords for the htpasswd file."
    echo "Enter empty username when you are done."
    echo
    if [[ "${secret_method}" == "htpasswd-plain" ]]; then
      htpasswd_options="-p"
      echo "NOTE: All passwords will be stored in plain text. You should not use"
      echo "them for anything important. Use method 'htpasswd' instead if you"
      echo "want to encrypt all passwords"
    else
      htpasswd_options=""
      echo "NOTE: All passwords will be encrypted. Thus, you should store all credentials"
      echo "to a safe location so that you can remember them later. Use a password manager"
      echo "for example."
    fi
    while echo && echo "username: " && read -r username && [[ ${username} ]]
    do
      until htpasswd ${htpasswd_options} "${secret_value}" "${username}"; do :; done
    done
    if [[ "${secret_method}" == "htpasswd-plain" ]]; then
      sed -i -- "s/:/:{PLAIN}/" "${secret_value}"
    fi
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

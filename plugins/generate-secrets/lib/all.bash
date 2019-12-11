#!/bin/bash

function generate-secrets::create_and_export () {
  local skip_confirm=${1}
  local secret_name
  local exports=""
  local secret_index=0
  local secret_names=(${taito_secret_names})

  local prefix="${taito_project:-}-${taito_env:-}-"

  for secret_name in ${secret_names[@]}; do
    taito::expose_secret_by_index ${secret_index}
    if [[ ${secret_method} != "read/"* ]] && (
         [[ -z "${name_filter}" ]] ||
         [[ ${secret_name} == *"${name_filter}"* ]]
       ) && (
         [[ ${skip_confirm} == "true" ]] || (
           taito::print_title "${secret_name/$prefix/}"
           taito::confirm \
             "Create new value for '${secret_name/$prefix/}' with method ${secret_method:-}"
         )
       )
    then
      if [[ ${skip_confirm} == "true" ]]; then
        taito::print_title "${secret_name/$prefix/}"
      fi
      generate-secrets::generate_by_type "${secret_index}" "${secret_name/$prefix/}"
    fi
    secret_index=$((${secret_index}+1))
  done

  eval "$exports"
}

function generate-secrets::delete_temporary_files () {
  local secret_name
  local file

  local secret_index=0
  local secret_names=(${taito_secret_names})
  for secret_name in ${secret_names[@]}
  do
    taito::expose_secret_by_index ${secret_index}
    if [[ ${secret_changed:-} ]] && \
       [[ ${secret_value:-} == "secret_file:"* ]]; then
      set -e
      file="${secret_value#secret_file:}"
      echo "Deleting file '${file}'"
      rm -f "${file}"
      echo "File '${file}' deleted successfully"
    fi
    secret_index=$((${secret_index}+1))
  done
}

function generate-secrets::generate_by_type () {
  taito::expose_secret_by_index "${1}"
  local title=$2

  # local secret_value=""
  # local secret_value2=""
  #
  # local secret_value
  # local secret_method
  # local key_file
  # local csr_file
  # local opts
  # local htpasswd_options

  secret_value=
  if [[ ${secret_default_value:-} ]] && \
     [[ ${secret_method} != "random" ]] && \
     taito::confirm \
       "Default value exists. Use the default value for ${taito_env} environment?"
  then
    secret_value="${secret_default_value}"
  fi

  if [[ -z "${secret_value}" ]]; then
    case "${secret_method}" in
      manual)
        if [[ ${taito_provider:-} == "azure" ]] && \
           [[ ${secret_name} == *"storage"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can find the security credentials from the following webpage."
          echo
          echo "https://portal.azure.com/#@${taito_provider_org_id}/resource/subscriptions/${taito_provider_billing_account_id}/resourceGroups/${taito_resource_namespace_id}/providers/Microsoft.Storage/storageAccounts/${taito_project//-/}${taito_env//-/}/keys"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        if [[ ${taito_provider:-} == "aws" ]] && \
           [[ ${secret_name} == *"storage"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can find the security credentials from the following webpage."
          echo "Look for a user named: ${taito_project:-}-${taito_env}-application"
          echo
          echo "https://console.aws.amazon.com/iam/home?region=${taito_provider_region:-}#/users"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        while [[ ${#secret_value} -lt 8 ]] || [[ ${secret_value} != "${secret_value2}" ]]; do
          echo "New secret value (min 8 characters):"
          read -r -s secret_value
          echo "New secret value again:"
          read -r -s secret_value2
        done
        ;;
      file)
        opts=""
        if [[ ${google_authuser:-} ]]; then
          opts="authuser=${google_authuser}&"
        fi
        if [[ ${taito_provider:-} == "gcp" ]] &&
           [[ ${taito_type:-} != "zone" ]] &&
           [[ ${secret_name} == *"serviceaccount"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can download the service account key as json file from"
          echo "the following web page by pressing the 'create credentials' button."
          echo
          echo "https://console.cloud.google.com/apis/credentials?${opts}project=${taito_resource_namespace_id:-}"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        if [[ ${taito_provider:-} == "gcp" ]] &&
           [[ ${taito_type:-} == "zone" ]] &&
           [[ ${secret_name} == *"-ssl"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can download the database SSL certificates from"
          echo "the following web page by selecting connections tab of the correct"
          echo "database and then downloading server CA, client cert, and client key."
          echo
          echo "https://console.cloud.google.com/sql/instances?${opts}project=${taito_zone:?}"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        if [[ ${taito_provider:-} == "gcp" ]] &&
           [[ ${taito_type:-} == "zone" ]] &&
           [[ ${secret_name} == *"database-proxy"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can download the service account key as json file from"
          echo "the following web page by pressing the 'create credentials' button."
          echo
          echo "https://console.cloud.google.com/apis/credentials?${opts}project=${taito_zone:-}"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        while [[ ! -f ${secret_value} ]]; do
          echo "File path relative to project root folder (for example 'secret.json'):"
          read -r secret_value
        done
        secret_value="secret_file:${secret_value}"
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
          taito::executing_start
          openssl req -new -newkey rsa:2048 -nodes \
            -keyout "${key_file}" -out "${csr_file}"
        )
        secret_value="secret_file:${key_file}"
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
        file="./tmp/${secret_name}"
        rm -f "${file}"
        touch "${file}"
        echo "BASIC AUTH CREDENTIALS"
        echo
        echo "Basic autentication is typically used for hiding non-production"
        echo "environments from the public. Enter usernames and passwords below."
        echo "Enter an empty username when you are done."
        echo
        if [[ ${secret_method} == "htpasswd-plain" ]]; then
          htpasswd_options="-p"
          echo "NOTE: All passwords will be stored in plain text. You should not use"
          echo "them for anything important."
        else
          htpasswd_options=""
          echo "NOTE: All passwords will be encrypted. Thus, you should store all credentials"
          echo "to a safe location so that you can remember them later. Use a password manager"
          echo "for example."
        fi
        while echo && echo "username: " && read -r username && [[ ${username} ]]
        do
          until htpasswd ${htpasswd_options} "${file}" "${username}"; do :; done
        done
        if [[ ${secret_method} == "htpasswd-plain" ]]; then
          sed -i -- "s/:/:{PLAIN}/" "${file}"
        fi
        secret_value="secret_file:${file}"
        ;;
      random)
        if [[ ${taito_env} == "local" ]]; then
          echo "Using '${taito_default_password:?}' as random value for local environment"
          secret_value="${taito_default_password}"
        else
          secret_value=$(taito::print_random_string 30)
          echo "Random value generated"
        fi
        ;;
      *)
        if [[ ${secret_method} != "read/"* ]] && \
           [[ ${secret_method} != "copy/"* ]]; then
          echo "ERROR: Unknown secret method: ${secret_method}"
          exit 1
        fi
        ;;
    esac
  fi

  exports="${exports}export ${secret_value_var}=\"${secret_value}\"; export ${secret_changed_var}=\"true\"; "
}

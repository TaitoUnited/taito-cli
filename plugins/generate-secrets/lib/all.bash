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
    if [[ ${secret_orig_method} != "read/"* ]] && (
         [[ -z "${name_filter}" ]] ||
         [[ ${secret_name} == *"${name_filter}"* ]]
       ) && (
         [[ ${skip_confirm} == "true" ]] || (
           taito::print_title "${secret_name/$prefix/}"
           taito::confirm \
             "Create new value for '${secret_name/$prefix/}' with method ${secret_orig_method:-$secret_method:-}"
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
  local method="${secret_orig_method:-$secret_method}"

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
  if [[ ${secret_default_value:-} ]] &&
     [[ ${secret_method} != "random"* ]] &&
     [[ ${secret_orig_method} != "copy/"* ]] &&
     [[ ${secret_orig_method} != "read/"* ]] &&
     [[ ${secret_name} != *"serviceaccount"* ]] &&
     taito::confirm \
       "Default value exists. Use the default value for ${taito_env} environment?"
  then
    secret_value="${secret_default_value}"
  fi

  if [[ -z "${secret_value}" ]]; then
    case "${method%%-*}" in
      random)
        length=${secret_method##*-}
        if [[ ${length} == "random" ]]; then
          length=30
        elif [[ ${length} == "words" ]]; then
          length=6
        fi

        if [[ ${taito_env} == "local" ]]; then
          echo "Using '${taito_default_password:?}' as random value for local environment"
          secret_value="${taito_default_password}"
        elif [[ ${secret_method} == "random-words"* ]]; then
          secret_value=$(taito::print_random_words ${length})
          echo "Random words generated (${length} words)"
        elif [[ ${secret_method} == "random-uuid"* ]]; then
          secret_value=$(taito::print_random_uuid)
          echo "Random UUID generated"
        elif [[ ${secret_method} == "random"* ]]; then
          secret_value=$(taito::print_random_string ${length})
          echo "Random string generated (${length} characters)"
        fi
        ;;
      manual)
        minlength=${secret_method##*-}
        if [[ ${minlength} == "manual" ]]; then
          minlength=8
        fi
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
        if [[ ${secret_name} == *"version-control-buildbot"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "This is most likely a secret token used for tagging git repository and"
          echo "publishing release notes during production release. You can find it from"
          echo "your version control provider (${taito_vc_provider}) web user interface."
          echo "Note that the secret token is optional (you can enter anything)."
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        while [[ ${#secret_value} -lt ${minlength} ]] ||
              [[ ${secret_value} != "${secret_value2}" ]]
        do
          echo "New secret value (min ${minlength} characters):"
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
          echo "the following web page by selecting the correct service account and then"
          echo "pressing the 'add key' button."
          echo
          echo "https://console.cloud.google.com/apis/credentials?${opts}project=${taito_resource_namespace_id:-}"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi
        if [[ ${taito_provider:-} == "gcp" ]] &&
           [[ ${taito_type:-} == "zone" ]] &&
           [[ ${secret_name} == *"serviceaccount"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can download the service account key as json file from"
          echo "the following web page by selecting the correct service account and then"
          echo "pressing the 'add key' button."
          echo
          echo "https://console.cloud.google.com/apis/credentials?${opts}project=${taito_zone:-}"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        fi

        if [[ ${taito_provider:-} == "gcp" ]] &&
           [[ ${taito_type:-} == "zone" ]] &&
           [[ ${secret_name} == *"-db-ssl."* ]]; then
          echo ------------------------------------------------------------------------------
          echo "You most likely can download the database SSL certificates from"
          echo "the following web page by selecting connections tab of the correct"
          echo "database and then downloading server CA, client cert, and client key."
          echo
          echo "https://console.cloud.google.com/sql/instances?${opts}project=${taito_zone:?}"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        elif [[ ${taito_provider:-} == "aws" ]] &&
             [[ ${taito_type:-} == "zone" ]] &&
             [[ ${secret_name} == *"-ssl.ca"* ]]; then
          echo ------------------------------------------------------------------------------
          echo "This is probably a root certificate for your database. You can most"
          echo "likely download it from here:"
          echo
          echo "https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html"
          echo ------------------------------------------------------------------------------
          echo
          echo "[${title}]"
        elif [[ ${taito_type:-} == "zone" ]] &&
             [[ ${secret_name} == *"-ssl."* ]]; then
          echo ------------------------------------------------------------------------------
          echo "This is most likely a client certificate for your database. You can probably"
          echo "download it from your cloud provider database settings."
          echo ------------------------------------------------------------------------------
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
      htpasswd)
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
      template)
        mkdir -p ./tmp
        file="./tmp/${secret_name}"
        rm -f "${file}"
        touch "${file}"
        template_name=${secret_method#*-}
        sed "s/\$PROJECT/${taito_project//-/_}/g" "scripts/${template_name}" | \
          sed "s/\$ENV/${taito_env//-/_}/g" | \
          envsubst > "${file}"
        secret_value="secret_file:${file}"
        ;;
      *)
        if [[ ${method} != "read/"* ]] && \
           [[ ${method} != "copy/"* ]]; then
          echo "ERROR: Unknown secret method: ${method}"
          exit 1
        fi
        ;;
    esac
  fi

  exports="${exports}export ${secret_value_var}=\"${secret_value}\"; export ${secret_changed_var}=\"true\"; "
}

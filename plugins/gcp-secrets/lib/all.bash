#!/bin/bash

function get_secret_value () {
  local namespace=$1
  local secret_name=$2
  local secret_property=$3

  gcloud --project "${taito_provider_secrets_location:?}" secrets versions access latest \
    --secret="${namespace}/${secret_name}.${secret_property}"
}

function gcp-secrets::get_secret_value () {
  local zone=$1 # NOTE: intentionally not being used
  local namespace=$2
  local name=$3
  local secret_name
  local secret_property

  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  method=$(get_secret_value "${namespace}" "${secret_name}" "${secret_property}.METHOD")
  format=$(
    taito::get_secret_value_format "${method}"
  )

  if [[ ${format} == "file" ]]; then
    get_secret_value "${namespace}" "${secret_name}" "${secret_property}" |
      base64
  else
    get_secret_value "${namespace}" "${secret_name}" "${secret_property}"
  fi
}

function gcp-secrets::put_secret_value () {
  local zone=$1 # NOTE: intentionally not being used
  local namespace=$2
  local name=$3
  local method=$4
  local value=$5
  local filename=$6

  if [[ ${method} == "random"* ]] &&
     [[ ${taito_provider_secrets_mode:-} == "backup" ]]; then
    # Random secrets are not saved in backup mode
    return
  fi

  local secret_name
  local secret_property
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  local tmpfile
  tmpfile=$(mktemp)
  trap "rm -f ${tmpfile}" RETURN

  if ! gcloud --project "${taito_provider_secrets_location:?}" secrets describe \
    "${namespace}/${secret_name}.${secret_property}" &> /dev/null; then
    # Create new secret
    if [[ ${filename} ]]; then
      taito::executing_start
      gcloud --project "${taito_provider_secrets_location:?}" secrets create \
          "${namespace}/${secret_name}.${secret_property}" \
          --replication-policy="automatic" \
          --data-file="${filename}"
    else
      taito::executing_start
      echo -n "${value}" | \
        gcloud --project "${taito_provider_secrets_location:?}" secrets create \
          "${namespace}/${secret_name}.${secret_property}" \
          --replication-policy="automatic" \
          --data-file=-
    fi
  else
    # Update existing secret version
    if [[ ${filename} ]]; then
      taito::executing_start
      gcloud --project "${taito_provider_secrets_location:?}" secrets versions add \
          "${namespace}/${secret_name}.${secret_property}" \
          --data-file="${filename}"
    else
      taito::executing_start
      echo -n "${value}" | \
        gcloud --project "${taito_provider_secrets_location:?}" secrets versions add \
          "${namespace}/${secret_name}.${secret_property}" \
          --data-file=-
    fi
  fi
}

function gcp-secrets::delete_secret_value () {
  local zone=$1 # NOTE: intentionally not being used
  local namespace=$2
  local name=$3

  local secret_name
  local secret_property
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  taito::executing_start
  gcloud --project "${taito_provider_secrets_location:?}" secrets delete \
    "${namespace}/${secret_name}.${secret_property}"
}

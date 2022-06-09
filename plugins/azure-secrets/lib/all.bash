#!/bin/bash
# shellcheck source=../../azure/lib/all.bash
. "${taito_plugin_path:?}/../azure/lib/all.bash"

# function get_key () {
#   local location=$1
#   local namespace=$2
#   local name=$3

#   local secret_name
#   local secret_property
#   secret_name=$(taito::get_secret_name "${name}")
#   secret_property=$(taito::get_secret_property "${name}")

#   echo "/${location}/${namespace}/${secret_name}.${secret_property}"
# }

# function get_secret_value () {
#   local key=$1
#   azure::expose_azure_options

#   if [[ ${key} == ".METHOD" ]]; then
#     # Try to read METHOD from tags
#     value=$(
#       azure ${azure_options} secretsmanager describe-secret --output json \
#         --secret-id "${key}" 2> /dev/null | \
#           jq -r -e ".Tags[] | first(select(.Key == \"METHOD\")) | .Value"
#     ) || value=""
#   fi

#   if [[ ! ${value} ]]; then
#     value=$(
#       azure ${azure_options} secretsmanager get-secret-value --output json \
#         --secret-id "${key}" 2> /dev/null | \
#           jq -r -e '.SecretString'
#     ) || value=""
#   fi

#   echo "${value}"
# }

function azure-secrets::get_secret_value () {
  local zone=$1 # NOTE: intentionally not used
  local namespace=$2
  local name=$3
  local key

  if [[ ${name} == "azure-token.ossRdbms" ]]; then
    value=$(az account get-access-token --resource-type oss-rdbms | jq -r .accessToken)
  fi

  # key=$(get_key "${taito_provider_secrets_location:?}" "${namespace}" "${name}")
  # value=$(get_secret_value "${key}")
  # if [[ ! ${value} ]] && [[ ${taito_mode} == "ci" ]]; then
  #   # Try devops namespace instead (TODO: what is this hack? remove!)
  #   key=$(get_key "${taito_provider_secrets_location:?}" "devops" "${name}")
  #   value=$(get_secret_value "${key}")
  # fi
  
  echo "${value}"
}

function azure-secrets::put_secret_value () {
  # TODO

  # local zone=$1 # NOTE: intentionally not used
  # local namespace=$2
  # local name=$3
  # local method=$4
  # local value=$5
  # local filename=$6

  # if [[ ${method} == "random"* ]] &&
  #    [[ ${taito_provider_secrets_mode:-} == "backup" ]]; then
  #   # Random secrets are not saved in backup mode
  #   return
  # fi

  # local format
  # local key
  # if [[ ${filename} ]]; then
  #   format=$(taito::get_secret_value_format "${method}")
  #   if [[ ${format} == "file" ]]; then
  #     # Files are stored in Azure Key Vault as base64 encoded strings
  #     value=$(base64 -i "${filename}")
  #   else
  #     value=$(cat "${filename}")
  #   fi
  # fi

  # azure::expose_azure_options
  # key=$(get_key "${taito_provider_secrets_location:?}" "${namespace}" "${name}")

  # if azure ${azure_options} secretsmanager describe-secret --secret-id "${key}" &> /dev/null; then
  #   # Update existing secret
  #   azure ${azure_options} secretsmanager put-secret-value \
  #     --secret-id "${key}" \
  #     --secret-string "${value}"
  #   azure ${azure_options} secretsmanager tag-resource \
  #     --secret-id "${key}" \
  #     --tags "[ { \"Key\": \"METHOD\", \"Value\": \"${method}\" } ]"
  # else
  #   # Create new secret
  #   azure ${azure_options} secretsmanager create-secret \
  #     --name "${key}" \
  #     --tags "[ { \"Key\": \"METHOD\", \"Value\": \"${method}\" } ]" \
  #     --secret-string "${value}"
  # fi

  return
}

function azure-secrets::delete_secret_value () {
  # TODO

  # local zone=$1 # NOTE: intentionally not used
  # local namespace=$2
  # local name=$3
  # local key

  # azure::expose_azure_options
  # key=$(get_key "${taito_provider_secrets_location:?}" "${namespace}" "${name}")
  # azure ${azure_options} secretsmanager delete-secret --secret-id "${key}"

  return
}

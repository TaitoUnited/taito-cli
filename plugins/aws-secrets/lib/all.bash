#!/bin/bash
# shellcheck source=../../aws/lib/all.bash
. "${taito_plugin_path:?}/../aws/lib/all.bash"

function get_key () {
  local location=$1
  local namespace=$2
  local name=$3

  local secret_name
  local secret_property
  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  echo "/${location}/${namespace}/${secret_name}.${secret_property}"
}

function get_secret_value () {
  local key=$1
  aws::expose_aws_options

  if [[ ${key} == ".METHOD" ]]; then
    # Try to read METHOD from tags
    value=$(
      aws ${aws_options} secretsmanager describe-secret --output json \
        --secret-id "${key}" 2> /dev/null | \
          jq -r -e ".Tags[] | first(select(.Key == \"METHOD\")) | .Value"
    ) || value=""
  fi

  if [[ ! ${value} ]]; then
    value=$(
      aws ${aws_options} secretsmanager get-secret-value --output json \
        --secret-id "${key}" 2> /dev/null | \
          jq -r -e '.SecretString'
    ) || value=""
  fi

  echo "${value}"
}

function aws-secrets::get_secret_value () {
  local zone=$1 # NOTE: intentionally not used
  local namespace=$2
  local name=$3
  local key

  key=$(get_key "${taito_provider_secrets_location:?}" "${namespace}" "${name}")
  value=$(get_secret_value "${key}")
  if [[ ! ${value} ]] && [[ ${taito_mode} == "ci" ]]; then
    # Try devops namespace instead (TODO: what is this hack? remove!)
    key=$(get_key "${taito_provider_secrets_location:?}" "devops" "${name}")
    value=$(get_secret_value "${key}")
  fi
  echo "${value}"
}

function aws-secrets::put_secret_value () {
  local zone=$1 # NOTE: intentionally not used
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

  local format
  local key
  if [[ ${filename} ]]; then
    format=$(taito::get_secret_value_format "${method}")
    if [[ ${format} == "file" ]]; then
      # Files are stored in AWS Secrets Manager as base64 encoded strings
      value=$(base64 -i "${filename}")
    else
      value=$(cat "${filename}")
    fi
  fi

  aws::expose_aws_options
  key=$(get_key "${taito_provider_secrets_location:?}" "${namespace}" "${name}")

  if aws ${aws_options} secretsmanager describe-secret --secret-id "${key}" &> /dev/null; then
    # Update existing secret
    aws ${aws_options} secretsmanager put-secret-value \
      --secret-id "${key}" \
      --secret-string "${value}"
    aws ${aws_options} secretsmanager tag-resource \
      --secret-id "${key}" \
      --tags "[ { \"Key\": \"METHOD\", \"Value\": \"${method}\" } ]"
  else
    # Create new secret
    aws ${aws_options} secretsmanager create-secret \
      --name "${key}" \
      --tags "[ { \"Key\": \"METHOD\", \"Value\": \"${method}\" } ]" \
      --secret-string "${value}"
  fi
}

function aws-secrets::delete_secret_value () {
  local zone=$1 # NOTE: intentionally not used
  local namespace=$2
  local name=$3
  local key

  aws::expose_aws_options
  key=$(get_key "${taito_provider_secrets_location:?}" "${namespace}" "${name}")
  aws ${aws_options} secretsmanager delete-parameter --secret-id "${key}"
}

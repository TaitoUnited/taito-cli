#!/bin/bash

function get_secret_value () {
  local namespace=$1
  local secret_name=$2
  local secret_property=$3
  kubectl get secret "${secret_name}" -o yaml \
    --namespace="${namespace}" 2> /dev/null |
      grep "^  ${secret_property}:" |
      sed -e "s/^.*: //"
}

function kubectl::get_secret_value () {
  local zone=$1
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

  if [[ ${format} != "file" ]]; then
    get_secret_value "${namespace}" "${secret_name}" "${secret_property}" |
      base64 --decode
  else
    get_secret_value "${namespace}" "${secret_name}" "${secret_property}"
  fi
}

function kubectl::put_secret_value () {
  local zone=$1
  local namespace=$2
  local name=$3
  local method=$4
  local value=$5
  local filename=$6

  local secret_name
  local secret_property
  local secret_source

  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")
  if [[ ${filename} ]]; then
    secret_source="file"
  else
    secret_source="literal"
  fi

  # Secrets as json
  json=$(kubectl create secret generic "${secret_name}" \
    --namespace="${namespace}" \
    --from-${secret_source}=${secret_property}="${filename:-$value}" \
    --from-literal=${secret_property}.METHOD="${method}" \
    --dry-run=client -o json)

  if kubectl get secret "${secret_name}" --namespace="${namespace}" &> /dev/null
  then
    # Patch an existing secret
    # TODO: Do not just ignore fail, check if fail was ok (= not patched)
    data_only=$(echo "${json}" | jq '.data')
    kubectl patch secret "${secret_name}" \
      --namespace="${namespace}" \
      -p "{ \"data\": ${data_only} }" || :
  else
    # Create new secret
    kubectl::ensure_namespace "${namespace}"
    echo "${json}" | kubectl apply -f -
  fi
}

function kubectl::delete_secret_value () {
  local zone=$1
  local namespace=$2
  local name=$3
  local secret_name
  local secret_property

  secret_name=$(taito::get_secret_name "${name}")
  secret_property=$(taito::get_secret_property "${name}")

  # TODO: Do not just ignore fail, check if fail was ok (= not patched)
  taito::executing_start
  kubectl patch secret "${secret_name}" \
    --namespace="${namespace}" \
    -p "{ \"data\": { \"${secret_property}\": null, \"${secret_property}.METHOD\": null } }" || :
}

#!/bin/bash

: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_project:?}"
: "${taito_namespace:?}"
: "${kubectl_skip_restart:-}"

name_filter="${1}"

# Validate secret values
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  if [[ -z "${name_filter}" ]] || [[ ${secret_name} == *"${name_filter}"* ]]; then
    . "${taito_cli_path}/util/secret-by-index.sh"
    if [[ ${#secret_value} -lt 8 ]] && [[ ${secret_method} != "copy/"* ]] && [[ ${secret_method} != "read/"* ]]; then
      echo "ERROR: secret ${secret_namespace}/${secret_name} too short or not set"
      exit 1
    fi
  fi
  secret_index=$((${secret_index}+1))
done && \

# Save secret values
secret_index=0
for secret_name in "${secret_names[@]}"
do
  if [[ -z "${name_filter}" ]] || [[ ${secret_name} == *"${name_filter}"* ]]; then
    . "${taito_cli_path}/util/secret-by-index.sh"

    if [[ ${secret_method} == "copy/"* ]]; then
      echo "Copy ${secret_name} from ${secret_source_namespace} namespace"
      secret_value=$(kubectl get secret "${secret_name}" -o yaml \
        --namespace="${secret_source_namespace}" | grep "^  SECRET" | \
        sed -e "s/^.*: //" | base64 --decode)
      echo "Copied"
    fi

    if [[ ${secret_method} != "read/"* ]]; then
      kubectl create namespace "${secret_namespace}" &> /dev/null
      kubectl delete secret "${secret_name}" --namespace="${secret_namespace}" \
        2> /dev/null
      kubectl create secret generic "${secret_name}" \
        --namespace="${secret_namespace}" \
        --from-literal=SECRET="${secret_value}" \
        --from-literal=METHOD="${secret_method}"
      # shellcheck disable=SC2181
      if [[ $? -gt 0 ]]; then
       exit 1
      fi
      echo "- ${secret_name} saved"
    fi
  fi
  secret_index=$((${secret_index}+1))
done && \

# TODO remove this
# Copy all common secrets from common namespace
# echo "- Copying all secrets from common namespace"
# echo "TODO we should delete old ones first! use apply instead of create,
# but it fails in: the object has been modified"
# kubectl get secrets -o json --namespace common | \
#   jq ".items[].metadata.namespace = \"${taito_namespace}\"" \
#   | kubectl create -f  -

if [[ ${kubectl_skip_restart:-} != "true" ]]; then
  echo && \
  echo "--- kubectl: Restarting pods ---" && \
  echo "TODO rolling update instead of delete?" && \
  kubectl delete --all pods --namespace="${taito_namespace}"
else
  echo "--- NOTE: Skipping pod restart for refreshing secrets ---"
fi

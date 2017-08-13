#!/bin/bash

# TODO rename to get-secrets.sh

# Get secret values
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ ${secret_method} != "copy/"* ]]; then
    secret_value=$(kubectl get secret "${secret_name}" -o yaml \
      --namespace="${secret_source_namespace}" | grep "^  SECRET" | \
      sed -e "s/^.*: //" | base64 --decode)
    # shellcheck disable=SC2181
    if [[ $? -gt 0 ]]; then
      exit 1
    fi
    exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
    exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "
  fi

  secret_index=$((${secret_index}+1))
done

eval "$exports"

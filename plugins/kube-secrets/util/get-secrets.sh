#!/bin/bash

# Get secret values
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  if [[ ${secret_method} != "copy/"* ]] && \
     [[ ${secret_method} != "file" ]] && \
     [[ ${secret_method} != "csrkey" ]]; then

    # TODO remove once all project have been converted
    secret_property="SECRET"
    if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
      # TODO: ugly hack that currently occurs in 3 places
      secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
      secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
    fi

    echo "+ kubectl get secret ${secret_name}" \
      "--namespace=${secret_source_namespace} ..." > "${taito_vout:?}"
    secret_value=$(kubectl get secret "${secret_name}" -o yaml \
      --namespace="${secret_source_namespace}" 2> /dev/null | grep "^  ${secret_property}" | \
      sed -e "s/^.*: //" | base64 --decode)
    set +x
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

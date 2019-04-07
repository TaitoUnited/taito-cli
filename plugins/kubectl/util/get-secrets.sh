#!/bin/bash
: "${taito_project_path:?}"

# Get secret values
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_cli_path}/util/secret-by-index.sh"

  # TODO remove once all project have been converted
  secret_property="SECRET"
  if [[ "${taito_version:-}" -ge "1" ]] || [[ "${secret_name:0:12}" != *"."* ]]; then
    # TODO: ugly hack that currently occurs in 3 places
    secret_property=$(echo ${secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
    secret_name=$(echo ${secret_name} | sed 's/\([^\.]*\).*/\1/')
  fi

  echo "+ kubectl get secret ${secret_name}" \
    "--namespace=${secret_source_namespace} ..." > "${taito_vout:?}"

  base64=$(kubectl get secret "${secret_name}" -o yaml \
    --namespace="${secret_source_namespace}" 2> /dev/null | grep "^  ${secret_property}:" | \
    sed -e "s/^.*: //")
  if [[ "${secret_method}" == "random" ]] || \
     [[ "${secret_method}" == "manual" ]]; then
    secret_value=$(echo "${base64}" | base64 --decode)
  else
    mkdir -p "${taito_project_path}/tmp/secrets"
    file="${taito_project_path}/tmp/secrets/${secret_name}"
    echo "${base64}" | base64 --decode > "${file}"
    secret_value="secret_file:${file}"
  fi
  set +x
  # shellcheck disable=SC2181
  if [[ $? -gt 0 ]]; then
    exit 1
  fi
  exports="${exports}export ${secret_value_var}=\"${secret_value}\"; "
  exports="${exports}export ${secret_value_var2}=\"${secret_value}\"; "

  secret_index=$((${secret_index}+1))
done

eval "$exports"

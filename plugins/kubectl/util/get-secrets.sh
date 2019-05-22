#!/bin/bash
: "${taito_project_path:?}"
: "${taito_env:?}"
: "${taito_vout:?}"

save_to_disk=$1
filter=$2

# Get secret values
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in "${secret_names[@]}"
do
  . "${taito_util_path}/secret-by-index.sh"

  if [[ -n ${filter} ]] && \
     [[ "${secret_name}" != *"${filter}"* ]]; then
    secret_index=$((${secret_index}+1))
    continue
  fi

  # TODO remove once all project have been converted
  secret_property="SECRET"
  formatted_secret_name=${secret_name//_/-}
  if [[ "${taito_version:-}" -ge "1" ]] || [[ "${formatted_secret_name:0:12}" != *"."* ]]; then
    # TODO: ugly hack that currently occurs in 3 places
    secret_property=$(echo ${formatted_secret_name} | sed 's/[^\.]*\.\(.*\)/\1/')
    formatted_secret_name=$(echo ${formatted_secret_name} | sed 's/\([^\.]*\).*/\1/')
  fi

  echo "+ kubectl get secret ${formatted_secret_name}" \
    "--namespace=${secret_source_namespace} ..." > "${taito_vout}"

  secret_value=""
  base64=$(kubectl get secret "${formatted_secret_name}" -o yaml \
    --namespace="${secret_source_namespace}" 2> /dev/null | grep "^  ${secret_property}:" | \
    sed -e "s/^.*: //")

  # write secret value to file
  if [[ "${save_to_disk}" == "true" ]]; then
    mkdir -p "${taito_project_path}/tmp/secrets/${taito_env}"
    file="${taito_project_path}/tmp/secrets/${taito_env}/${secret_name}"
    echo "Saving secret to ${file}" > "${taito_vout}"
    echo "${base64}" | base64 --decode > "${file}"
    # TODO: save to a separate env var (secret_value should always be value)
    secret_value="secret_file:${file}"
  fi

  if [[ "${secret_method:?}" == "random" ]] || \
     [[ "${secret_method}" == "manual" ]] || (
       [[ "${secret_method}" == "htpasswd"* ]] && \
       [[ "${save_to_disk}" == "false" ]] \
     ); then
    # use secret as value instead of file path
    secret_value=$(echo "${base64}" | base64 --decode)
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

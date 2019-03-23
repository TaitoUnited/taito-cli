#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

skip_confirm=${1}

exports=""
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_cli_path}/util/secret-by-index.sh"
  if [[ "${secret_method}" != "read/"* ]] && ( \
       [[ -z "${name_filter}" ]] || \
       [[ ${secret_name} == *"${name_filter}"* ]] \
     ) && ( \
       [[ ${skip_confirm} == "true" ]] || \
       "${taito_cli_path}/util/confirm-execution.sh" "${secret_name}" "" \
         "Create new value for secret '${secret_name}'\\nwith method: ${secret_method:-}"
     )
  then
    if [[ ${skip_confirm} == "true" ]]; then
      echo "Creating new value for secret '${secret_name}'"
      echo "with method: ${secret_method:-}"
    fi
    . "${taito_plugin_path}/util/create-by-type.sh"
  fi
  secret_index=$((${secret_index}+1))
done && \

eval "$exports"

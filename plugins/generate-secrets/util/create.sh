#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

skip_confirm=${1}

exports=""
secret_index=0
secret_names=(${taito_secret_names})
for secret_name in ${secret_names[@]}
do
  . "${taito_util_path}/secret-by-index.sh"
  if [[ "${secret_method}" != "read/"* ]] && ( \
       [[ -z "${name_filter}" ]] || \
       [[ ${secret_name} == *"${name_filter}"* ]] \
     ) && ( \
       [[ ${skip_confirm} == "true" ]] || \
       "${taito_util_path}/confirm-execution.sh" "${secret_name}" "" \
         "Create new value for '${secret_name}' with method ${secret_method:-}"
     )
  then
    if [[ ${skip_confirm} == "true" ]]; then
      echo -e "${H2s}${secret_name} (${secret_method:-})${H2e}"
    fi
    . "${taito_plugin_path}/util/create-by-type.sh"
  fi
  secret_index=$((${secret_index}+1))
done && \

eval "$exports"

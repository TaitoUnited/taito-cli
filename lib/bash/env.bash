#!/bin/bash

function taito::export_terraform_env () {
  # Set terraform basic settings
  export TF_LOG="INFO"
  export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"

  # Export storage attributes in array format
  taito::export_storage_attributes

  # Export taito_container_targets
  # TODO: just use taito_containers directly in terraform module
  export taito_container_targets
  taito_container_targets="${taito_containers:-}"

  # Export taito_function_targets
  # TODO: just use taito_functions directly in terraform module
  export taito_function_targets
  taito_function_targets="${taito_functions:-}"

  # Export environment variables as TF_VAR terraform variables.
  # In addition, format the value to list(string) if the name ends with 's'.
  echo "Setting up terraform variables" > "${taito_vout}"
  names=$(
    awk 'BEGIN{for(v in ENVIRON) print v}' |
    grep -v 'BASH_FUNC' | grep -v '^link_' | grep "._." | sort
  )
  for name in ${names}; do
    value="${!name}"

    # TODO: remove (here temporarily for backwards compatibility)
    value_formatted="${value}"
    if [[ ${name: -1} == "s" ]] &&
       [[ -f "${scripts_path}/variables.tf" ]] &&
       grep "list(string)" "${scripts_path}/variables.tf" &> /dev/null; then
      # Format to terraform list
      value_formatted="["
      words=("${value}")
      for word in ${words[@]}
      do
        value_formatted="${value_formatted}\"${word}\","
      done
      # Remove last , and add ]
      value_formatted="${value_formatted%?}]"
    fi

    local tf_name="TF_VAR_${name}"
    if [[ ! ${!tf_name} ]]; then
      echo "- ${tf_name}=${value_formatted}" > "${taito_vout}"
      export "${tf_name}"="${value_formatted}" || echo failed
    fi
  done
}
export -f taito::export_terraform_env

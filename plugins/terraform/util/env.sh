#!/bin/bash
: "${taito_vout:?}"
: "${taito_resource_namespace:?}"

# Set terraform basic settings
export TF_LOG="INFO"
export TF_LOG_PATH="./${taito_resource_namespace}/terraform.log"
export TF_PLUGIN_CACHE_DIR="/${HOME}/.terraform.d/plugin-cache"

# Export all taito_xxx environment variables as TF_VAR terraform variables.
# If name ends with 's', format value to a terraform list.
echo "Setting up terraform variables" > "${taito_vout}"
env_exports=""
while IFS='=' read -r name value ; do
  if [[ "${name}" == *"_"* ]] && \
     [[ "${name}" != "link_"* ]] && \
     [[ -n "${value}" ]]; then
    value_formatted="${value}"
    if [[ "${name: -1}" == "s" ]]; then
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
    env_exports="${env_exports}export TF_VAR_${name}='${value_formatted}'; "
    echo "- ${name}=${value_formatted}" > "${taito_vout}"
  fi
done < <(env | sort)

eval "${env_exports}"

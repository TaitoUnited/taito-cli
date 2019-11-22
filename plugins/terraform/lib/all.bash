#!/bin/bash

function terraform::export_env () {
  # Set terraform basic settings
  export TF_LOG="INFO"
  export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"

  # Export storage attributes in array format
  taito::export_storage_attributes

  # Export taito_container_targets
  export taito_container_targets
  taito_container_targets=$(taito::print_targets_of_type container)

  # Export taito_function_targets
  export taito_function_targets
  taito_function_targets=$(taito::print_targets_of_type function)

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
       grep "list(string)" "${scripts_path}/variables.tf"; then
      echo AARGH!
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

function terraform::run () {
  local command=${1}
  local name=${2}
  local env=${3}
  local scripts_path=${4:-scripts/terraform/$name}

  local options=""
  if [[ ${taito_mode:-} == "ci" ]] && [[ ${command} == "apply" ]]; then
    options="-auto-approve"
  fi

  if [[ -d "${scripts_path}" ]] && \
     taito::confirm "Run terraform scripts for ${name}"
  then
    (
      echo "Substituting variables in ./scripts/terraform*.yaml files" > "${taito_vout}"
      dest=./scripts/terraform.tmp
      envsubst < "./scripts/terraform-${taito_target_env:-}.yaml" > $dest || \
        envsubst < "./scripts/terraform.yaml" > $dest || :

      export TF_LOG_PATH="./${env}/terraform.log"
      terraform::export_env "${scripts_path}"
      cd "${scripts_path}" || exit 1
      mkdir -p "./${env}"
      terraform init -backend-config="../common/backend.tf"
      if [[ -f import_state ]]; then
        ./import_state
      fi
      # TODO: Remove hadcoded taint
      terraform taint aws_api_gateway_deployment.gateway || :
      terraform "${command}" ${options} -state="./${env}/terraform.tfstate"
      rm -f "${dest}"
    )
  fi
}

function terraform::run_zone () {
  local command=${1}
  local scripts_path=${2:-terraform}

  export TF_LOG_PATH="./terraform.log"
  terraform::export_env "${scripts_path}"
  cd "${scripts_path}" || exit 1
  terraform init
  if [[ -f import_state ]]; then
    ./import_state
  fi
  terraform "${command}"
}

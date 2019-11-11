#!/bin/bash

function terraform::export_env () {
  # Set terraform basic settings
  export TF_LOG="INFO"
  export TF_PLUGIN_CACHE_DIR="/${HOME}/.terraform.d/plugin-cache"

  # Export all environment variables as TF_VAR terraform variables.
  # If name ends with 's', format value to a terraform list.
  echo "Setting up terraform variables" > "${taito_vout}"
  while IFS='=' read -r name value ; do
    if [[ ${name} == *"_"* ]] && \
       [[ ${name} != "link_"* ]] && \
       [[ ${value} ]]; then
      value_formatted="${value}"
      if [[ ${name: -1} == "s" ]]; then
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
      echo "- ${name}=${value_formatted}" > "${taito_vout}"
      export TF_VAR_${name}="${value_formatted}" || echo failed
    fi
  done < <(set -o posix; set | sed -z 's/\n  / /g' | sed "s/='/=/" | sed "s/'$//" | sort)
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
      export TF_LOG_PATH="./${env}/terraform.log"
      terraform::export_env
      cd "${scripts_path}" || exit 1
      mkdir -p "./${env}"
      terraform init -backend-config="../common/backend.tf"
      if [[ -f import_state ]]; then
        ./import_state
      fi
      # TODO: Remove hadcoded taint
      terraform taint aws_api_gateway_deployment.gateway || :
      terraform "${command}" ${options} -state="./${env}/terraform.tfstate"
    )
  fi
}

function terraform::run_zone () {
  local command=${1}
  local scripts_path=${2:-terraform}

  export TF_LOG_PATH="./terraform.log"
  terraform::export_env
  cd "${scripts_path}" || exit 1
  terraform init
  if [[ -f import_state ]]; then
    ./import_state
  fi
  terraform "${command}"
}

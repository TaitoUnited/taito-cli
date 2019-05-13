#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_provider:?}"
: "${taito_resource_namespace:?}"

name=${1}

if [[ -f "./scripts/terraform/${taito_provider}" ]] && \
   "${taito_cli_path}/util/confirm-execution.sh" "terraform" "${name}" \
     "Destroy ${taito_env} environment by running terraform"
then
  (
    export TF_LOG_PATH="./${taito_env}/terraform.log"
    # shellcheck disable=SC1090
    . "${taito_plugin_path}/util/env.sh" && \
    cd "./scripts/terraform/${taito_provider}" && \
    terraform init -backend-config="../common/backend.tf" && \
    if [[ -f import_state.sh ]]; then
      ./import_state.sh
    fi && \
    terraform destroy -state="./${taito_env}/terraform.tfstate"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

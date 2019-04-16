#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_provider:?}"
: "${taito_env:?}"
: "${taito_resource_namespace:?}"
: "${taito_resource_namespace_id:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "terraform" "${name}" \
  "Apply changes to ${taito_env} environment by running terraform scripts"
then
  (
    export TF_LOG_PATH="./${taito_env}/terraform.log"
    # shellcheck disable=SC1090
    . "${taito_plugin_path}/util/env.sh" && \
    cd "./scripts/terraform/${taito_provider}" && \
    mkdir -p "./${taito_env}" && \
    terraform init -backend-config="../common/backend.tf" && \
    if [[ -f import_state.sh ]]; then
      ./import_state.sh
    fi && \
    terraform apply -state="./${taito_env}/terraform.tfstate"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

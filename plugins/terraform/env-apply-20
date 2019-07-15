#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_provider:?}"
: "${taito_env:?}"
: "${taito_resource_namespace:?}"
: "${taito_resource_namespace_id:?}"

name=${1}

# NOTE: For backwards compatibility
if [[ $taito_provider == "gcp" ]] && [[ -d "./scripts/terraform/gcloud" ]]; then
  taito_provider=${taito_provider//gcp/gcloud}
  taito_uptime_provider=${taito_uptime_provider//gcp/gcloud}
fi

if [[ -d "./scripts/terraform/${taito_provider}" ]] && \
   "${taito_util_path}/confirm-execution.sh" "terraform" "${name}" \
     "Run terraform scripts for cloud provider ${taito_provider}"
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

# TODO: duplicate code
if [[ -d "./scripts/terraform/${taito_uptime_provider:-}-uptime" ]] && \
   "${taito_util_path}/confirm-execution.sh" "terraform" "${name}" \
     "Run terraform scripts for uptime provider ${taito_uptime_provider}"
then
  (
    export TF_LOG_PATH="./${taito_env}/terraform.log"
    # shellcheck disable=SC1090
    . "${taito_plugin_path}/util/env.sh" && \
    cd "./scripts/terraform/${taito_uptime_provider}-uptime" && \
    mkdir -p "./${taito_env}" && \
    terraform init -backend-config="../common/backend.tf" && \
    if [[ -f import_state.sh ]]; then
      ./import_state.sh
    fi && \
    terraform apply -state="./${taito_env}/terraform.tfstate"
  )
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

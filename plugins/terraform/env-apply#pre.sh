#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_provider:?}"
: "${taito_env:?}"
: "${taito_resource_namespace:?}"
: "${taito_resource_namespace_id:?}"

name=${1}

if "${taito_cli_path}/util/confirm-execution.sh" "terraform" "${name}" \
  "Apply changes to environment ${taito_env} by running terraform scripts"
then
  echo
  echo "Terraform is currently used only for creating new resources for"
  echo "an existing project. Make sure that project '${taito_resource_namespace}'"
  echo "exists and has '${taito_resource_namespace_id}' as an id."
  echo "You also might need to enable billing for it."
  echo
  if [[ "${taito_provider}" == "gcloud" ]]; then
    echo "NOTE: Also enable the Compute Engine API before continuing"
  fi
  echo
  echo "Continue (Y/n)?"
  read -r confirm
  if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
    exit 130
  fi

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

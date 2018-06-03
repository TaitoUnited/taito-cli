#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_provider:?}"
: "${taito_resource_namespace:?}"

echo "Terraform is currently used only for creating new resources for"
echo "an existing project. Make sure that project ${taito_resource_namespace}"
echo "exists. You also might need to enable billing for it."
echo
echo "Does the project ${taito_resource_namespace} exist already?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_provider}" && \
  terraform init -backend-config="../common/backend.tf" && \
  ./import_state.sh && \
  terraform apply -state="./${taito_resource_namespace}/terraform.tfstate"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_provider:?}"
: "${taito_resource_namespace:?}"
: "${taito_resource_namespace_id:?}"

echo
echo "Terraform is currently used only for creating new resources for"
echo "an existing project. Make sure that project ${taito_resource_namespace}" echo "exists and has '${taito_resource_namespace_id}' as an id."
echo "You also might need to enable billing for it."
echo
if [[ "${taito_provider}" == "gcloud" ]]; then
  echo "NOTE: Also enable the Compute Engine API before continuing"
fi
echo
echo "Continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_provider}" && \
  mkdir -p "./${taito_resource_namespace}" && \
  terraform init -backend-config="../common/backend.tf" && \
  ./import_state.sh && \
  terraform apply -state="./${taito_resource_namespace}/terraform.tfstate"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

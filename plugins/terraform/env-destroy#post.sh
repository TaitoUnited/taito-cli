#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_provider:?}"
: "${taito_resource_namespace:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_provider}" && \
  terraform init -backend-config="../common/backend.tf" && \
  ./import_state.sh && \
  terraform destroy -state="./${taito_resource_namespace}/terraform.tfstate"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

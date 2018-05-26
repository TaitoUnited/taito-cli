#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_provider:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_provider}" && \
  terraform init -backend-config="../common/backend.tf" && \
  ./import_state.sh && \
  terraform apply -state="./${taito_env}/terraform.tfstate"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

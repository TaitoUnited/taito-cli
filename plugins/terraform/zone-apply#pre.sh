#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"
: "${taito_provider:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_provider}" && \
  terraform init && \
  ./import_state.sh && \
  terraform apply
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

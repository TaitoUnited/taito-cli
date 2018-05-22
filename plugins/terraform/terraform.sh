#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_env}" && \
  terraform "${@}"
) && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

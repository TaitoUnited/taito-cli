#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_provider:?}"

# shellcheck disable=SC1090
. "${taito_plugin_path}/util/env.sh" && \
(
  cd "./scripts/terraform/${taito_provider}" && \
  terraform "${@}"
) && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

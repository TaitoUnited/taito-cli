#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

change="${1}"

"${taito_plugin_path}/util/sqitch.sh" rebase ${change} \
  --set env="'${taito_env}'" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

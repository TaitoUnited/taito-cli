#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

"${taito_plugin_path}/util/sqitch.sh" revert "${@}" \
  --set env="'${taito_env}'" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

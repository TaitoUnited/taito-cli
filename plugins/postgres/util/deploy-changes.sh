#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

"${taito_plugin_path}/util/sqitch.sh" deploy --set env="'${taito_env}'"
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

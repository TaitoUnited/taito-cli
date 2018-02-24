#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

"${taito_plugin_path}/util/sqitch.sh" deploy --set env="'${taito_env}'"

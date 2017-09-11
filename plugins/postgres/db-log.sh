#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

echo
echo "### postgres - db-log: Showing db migration log of ${taito_env} ###"

"${taito_plugin_path}/util/sqitch.sh" log && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

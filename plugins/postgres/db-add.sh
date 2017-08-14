#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

echo
echo "### postgres - db-add: Adding new step to migration plan ###"
echo

"${taito_plugin_path}/util/sqitch.sh" add "${@:1}"
# shellcheck disable=SC2181
if [[ $? -gt 0 ]]; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

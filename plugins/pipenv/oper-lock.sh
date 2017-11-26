#!/bin/bash

: "${taito_cli_path:?}"

echo
echo "### pipenv - oper-lock: Locking packages ###"

"${taito_cli_path}/util/execute-on-host-fg.sh" \
  "pipenv lock"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

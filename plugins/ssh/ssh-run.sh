#!/bin/bash
: "${taito_cli_path:?}"

opts=""
if [[ -f "${HOME}/.ssh/config.taito" ]]; then
  opts="-F${HOME}/.ssh/config.taito"
fi
ssh "${opts}" "${@}"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

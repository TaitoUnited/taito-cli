#!/bin/bash
: "${taito_cli_path:?}"

if [[ ${taito_commands_only_chain:-} == *"-db/"* ]]; then
  echo
  echo "### aws/post: Stopping all db proxies"
  echo "TODO implement"
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

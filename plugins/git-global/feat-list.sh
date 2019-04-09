#!/bin/bash -e
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  git branch -a 2> /dev/null | grep \" feature/\" | sed -e 's|feature/||'
fi
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
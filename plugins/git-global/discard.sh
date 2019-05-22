#!/bin/bash -e
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  git clean -df
  git checkout -- .
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  read -t 1 -n 1000 discard || :
  read -p \"Create a new commit that reverts the latest commit? [y/N] \" -n 1 -r confirm
  echo
  if [[ \${confirm} =~ ^[Yy]$ ]]; then
    git revert HEAD
  else
    echo Cancelled
  fi
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

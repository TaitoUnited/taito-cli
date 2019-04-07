#!/bin/bash -e
: "${taito_cli_path:?}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  echo \"Create a new commit that reverts the latest commit (Y/n)?\"
  read -r confirm
  if [[ \${confirm} =~ ^[Yy]$ ]]; then
    git revert HEAD
  fi
fi
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

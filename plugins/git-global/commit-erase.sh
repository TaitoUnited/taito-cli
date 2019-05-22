#!/bin/bash -e
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  branch=\$(git symbolic-ref --short HEAD)
  echo
  echo Try to avoid using this command if it is likely that someone else has already pulled
  echo or merged your latest commit. In such case using 'commit revert' might be
  echo a better idea. Also note that this command will not push changes to the remote
  echo branch if your local branch is not up-to-date.
  echo
  echo \"Forcefully erase the latest commit from local and remote \${branch} branch (y/N)?\"
  read -r confirm
  if [[ \${confirm} =~ ^[Yy]$ ]]; then
    git reset HEAD^ --hard && git push origin --no-verify --force-with-lease
  fi
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

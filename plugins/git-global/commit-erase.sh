#!/bin/bash -e
: "${taito_util_path:?}"

"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  branch=\$(git symbolic-ref --short HEAD)
  echo WARNING:
  echo Try to avoid using this command if it is likely that someone else has already
  echo pulled or merged your latest commit. In such case using 'commit revert' might
  echo be a better idea. Also note that this command will not push changes to the
  echo remote branch if your local branch is not up-to-date.
  echo
  read -t 1 -n 1000 discard || :
  read -p \"Forcefully erase the latest commit from local and remote \${branch} branch? [y/N] \" -n 1 -r confirm
  echo
  if [[ \${confirm} =~ ^[Yy]$ ]]; then
    git reset HEAD^ --hard && git push origin --no-verify --force-with-lease
  else
    echo Cancelled
  fi
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

source="${taito_branch:-dev}"

"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null && \
   ! git checkout feature/${1} 2> /dev/null && \
   [[ \"${1}\" ]]; then
  dest=\"feature/${1}\"
  echo \"Creating a new branch: \${dest}\"
  read -t 1 -n 1000 discard || :
  read -p \"Do you want to continue? [Y/n] \" -n 1 -r confirm
  echo
  if ! [[ \${confirm} =~ ^[Yy]*$ ]]; then
    echo Cancelled
    exit 130
  fi
  git checkout ${source}
  git pull
  git checkout -b \${dest}
  echo
  echo TODO explain when to push to remote repository
  read -t 1 -n 1000 discard || :
  read -p \"Push the \${dest} branch to the remote repository? [y/N] \" -n 1 -r confirm
  echo
  if [[ \${confirm} =~ ^[Yy]$ ]]; then
    git push --no-verify -u origin \${dest} || \
      echo NOTE: Push failed. Fix errors and the run \'push -u origin \${dest}\'.
  fi
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

source="${taito_branch:-dev}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null && \
   ! git checkout feature/${1} 2> /dev/null && \
   [[ \"${1}\" ]]; then
  dest=\"feature/${1}\"
  echo \"Creating a new branch: \${dest}. Do you want to continue (Y/n)?\"
  read -r confirm
  if ! [[ \${confirm} =~ ^[Yy]*$ ]]; then
    echo Cancelled
    exit 130
  fi
  git checkout ${source}
  git pull
  git checkout -b \${dest}
  echo
  echo TODO explain when to push to remote repository
  echo \"Push the \${dest} branch to the remote repository (y/N)?\"
  read -r confirm
  if [[ \${confirm} =~ ^[Yy]$ ]]; then
    git push --no-verify -u origin \${dest} || \
      echo NOTE: Push failed. Fix errors and the run \'push -u origin \${dest}\'.
  fi
fi
"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

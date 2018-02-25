#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

source="${taito_branch:-dev}"
dest="feature/${1:?Feature name not given}"

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
if ! git checkout ${dest} 2> /dev/null; then \
  echo 'Creating a new branch: ${dest}. Do you want to continue (Y/n)?' && \
  read -r confirm && \
  if ! [[ \${confirm} =~ ^[Yy]$ ]]; then \
    echo Cancelled && \
    exit 130; \
  fi && \
  git checkout ${source} && \
  git pull && \
  git checkout -b ${dest} && \
  echo 'Push the ${dest} branch to remote repository (y/N)?' && \
  read -r confirm && \
  if [[ \${confirm} =~ ^[Yy]$ ]]; then \
    git push -u origin ${dest} || \
    echo NOTE: Push failed. Fix errors and the run \'push -u origin ${dest}\'.
  fi && \
fi \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

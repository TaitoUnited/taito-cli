#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

source=${1}
dest=${2:-dev}

echo
echo "### git - git-merge-feat: Merging ${source} to ${dest} ###"
echo

echo "Rebase branch ${source} before merge (Y/n)?"
read -r rebase

echo "Delete branch ${source} after merge (Y/n)?"
read -r del

"${taito_cli_path}/util/execute-on-host.sh" "\
  if [[ ${rebase} =~ ^[Yy]$ ]]; then \
    git checkout ${source} && git rebase -i ${dest} && git checkout -; \
  fi; \
  git checkout ${dest} && \
  git pull && \
  git merge ${source} && \
  git commit -v && \
  git push && \
  if [[ ${del} =~ ^[Yy]$ ]]; then \
    git branch -d ${source}; git push origin --delete ${source} &> /dev/null; \
  else \
    git checkout -; \
  fi; \
  "

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

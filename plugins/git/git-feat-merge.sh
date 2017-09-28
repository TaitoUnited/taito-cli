#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

dest="${taito_branch:-dev}"
feature="feature/${1:?Feature name not given}"

echo
echo "### git - git-feat-merge: Merging ${feature} to ${dest} ###"

# diff-index -> Commit only if there is something to commit
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  echo 'Rebase branch ${feature} before merge (Y/n)?' && \
  read -r rebase && \
  if [[ \${rebase} =~ ^[Yy]$ ]]; then \
    git checkout ${feature} && git rebase -i ${dest} && git checkout -; \
  fi && \
  git checkout ${dest} && \
  git pull && \
  git merge ${feature} && \
  (git diff-index --quiet HEAD || git commit -v) && \
  git push && \
  echo 'Delete branch ${feature} after merge (Y/n)?' && \
  read -r del && \
  if [[ \${del} =~ ^[Yy]$ ]]; then \
    git push origin --delete ${feature} &> /dev/null; \
    git branch -d ${feature}; \
  else \
    git checkout -; \
  fi; \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

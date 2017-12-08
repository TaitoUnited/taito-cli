#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

dest="${taito_branch:-dev}"
feature="feature/${1:?Feature name not given}"

echo "Squashing ${feature} to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# diff-index -> Commit only if there is something to commit
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git checkout ${dest} && \
  git pull && \
  git merge --squash ${feature} && \
  (git diff-index --quiet HEAD || git commit -v) && \
  git push && \
  git branch -D ${feature} && \
  (git push origin --delete ${feature} &> /dev/null || :) \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

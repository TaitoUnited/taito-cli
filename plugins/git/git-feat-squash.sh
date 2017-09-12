#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

feature="feature/${1:?Feature name not given}"
dest="${2:-dev}"

echo
echo "### git - git-feat-squash: Squash merging ${feature} to ${dest} ###"
echo

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

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

source=${1}
dest=${2:-dev}

echo
echo "### git - git-squash-feat: Squash merging ${source} to ${dest} ###"
echo

"${taito_cli_path}/util/execute-on-host.sh" "\
  git checkout ${dest} && \
  git pull && \
  git merge --squash ${source} && \
  git commit -v && \
  git push && \
  git branch -d ${source}; \
  git push origin --delete ${source} &> /dev/null; \
  "

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

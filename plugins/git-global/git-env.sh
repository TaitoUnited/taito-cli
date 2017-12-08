#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

source="${1:-dev}"
dest="${taito_branch:?Destination branch name not given}"

# TODO duplicate code with git-feat.sh?
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
    git push -u origin ${dest} \
  fi \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

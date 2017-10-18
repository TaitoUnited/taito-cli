#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

orig="${taito_branch:-dev}"
feature="feature/${1:?Feature name not given}"

echo
echo "### git - git-feat: Switching to ${feature} ###"
echo

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  if ! git checkout ${feature}; then \
    echo 'No such branch or some other error. Creating a new branch ${feature}. Do you want to continue (Y/n)?' && \
    read -r confirm && \
    if ! [[ \${confirm} =~ ^[Yy]$ ]]; then \
      echo Cancelled && \
      exit 130; \
    fi && \
    git checkout ${orig} && \
    git pull && \
    git checkout -b ${feature}; \
  fi \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

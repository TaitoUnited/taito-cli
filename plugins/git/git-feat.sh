#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

orig="${taito_branch:-dev}"
feature="feature/${1:?Feature name not given}"

echo
echo "### git - git-feat: Creating ${feature} for ${orig} ###"
echo

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  if ! git checkout ${feature}; then \
    git checkout ${orig} && \
    git pull && \
    git checkout -b ${feature}; \
  fi \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

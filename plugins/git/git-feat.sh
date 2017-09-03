#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

feature="feature/${1:?Feature name not given}"
orig="${2:-dev}"

echo
echo "### git - git-feat: Creating ${feature} for ${orig} ###"
echo

"${taito_cli_path}/util/execute-on-host.sh" "\
  git checkout ${orig} && \
  git pull && \
  git checkout -b ${feature}
  "

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

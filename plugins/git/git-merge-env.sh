#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

source=${1}
dest=${2}

echo
echo "### git - git-merge-env: Merging ${source} to ${dest} ###"
echo

"${taito_cli_path}/util/execute-on-host.sh" "\
  git fetch origin ${source}:${dest} && \
  git push origin ${dest}; \
  "

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

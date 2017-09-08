#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

source="${1:?Source branch name not given}"
dest="${2:?Destination branch name not given}"

echo
echo "### git - git-env-merge: Merging ${source} to ${dest} ###"
echo

# TODO execute remote merge using hub cli?
"${taito_cli_path}/util/execute-on-host.sh" "\
  git fetch origin ${source}:${dest} && \
  git push origin ${dest}; \
  " && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

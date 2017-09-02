#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"

source=${1}
dest=${2}

echo
echo "### git - git-merge-env: Merging ${source} to ${dest} ###"
echo

if ! git fetch origin "${source}:${dest}"; then
  exit 1
fi
if ! git push origin "${dest}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

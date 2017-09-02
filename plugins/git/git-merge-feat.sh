#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

source=${1}
dest=${2:-dev}

echo
echo "### git - git-merge-feat: Merging ${source} to ${dest} ###"
echo

if ! git checkout "${dest}"; then
  exit 1
fi
if ! git merge --squash "${source}"; then
  exit 1
fi
if ! git commit -v; then
  exit 1
fi
if ! "${taito_plugin_path}/util/delete-branch.sh" "${source}" "${dest}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

source=${1}
dest=${2:-dev}

echo
echo "### git - git-squash-feat: Squash merging ${source} to ${dest} ###"
echo

if ! "${taito_plugin_path}/util/merge-branch.sh" "${source}" "${dest}" --squash; then
  exit 1
fi
if ! "${taito_plugin_path}/util/delete-branch.sh" "${source}" "${dest}" "true"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

source=${1}
dest=${2:-dev}

echo
echo "### git - git-merge-feat: Merging ${source} to ${dest} ###"
echo

if [[ ! -f "${taito_project_path}/.git/rebase-merge" ]]; then
  if ! "${taito_plugin_path}/util/rebase-branch.sh" "${source}" "${dest}"; then
    exit 1
  fi
fi
if ! "${taito_plugin_path}/util/merge-branch.sh" "${source}" "${dest}"; then
  exit 1
fi
if ! "${taito_plugin_path}/util/delete-branch.sh" "${source}" "${dest}"; then
  exit 1
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

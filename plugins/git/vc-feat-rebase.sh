#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

dest="${taito_branch:-dev}"
if [[ ${1} ]]; then
  feature="feature/${1}"
else
  feature=$(git symbolic-ref --short HEAD)
fi

echo "Rebasing ${feature} with ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
  exit 130
fi

# diff-index -> Commit only if there is something to commit
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
git fetch --all && \
git checkout ${feature} && \
git rebase -i origin/${dest} && \
git checkout -; \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

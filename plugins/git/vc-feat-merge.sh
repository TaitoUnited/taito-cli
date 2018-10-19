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

echo "Merging ${feature} to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
  exit 130
fi

# diff-index -> Commit only if there is something to commit
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
echo 'Rebase branch ${feature} before merge (Y/n)?' && \
read -r rebase && \
if [[ \${rebase} =~ ^[Yy]*$ ]]; then \
  git fetch --all && \
  git checkout ${feature} && \
  git rebase -i origin/${dest} && \
  git checkout -; \
fi && \
git checkout ${dest} && \
git pull && \
git merge --no-ff ${feature} && \
(git diff-index --quiet HEAD || git commit -v) && \
( \
  git push || \
  echo NOTE: Push failed. Fix all errors first. Then push changes to ${dest} branch and delete the ${feature} branch. \
) && \
echo && \
echo 'Delete branch ${feature} (Y/n)?' && \
read -r del && \
if [[ \${del} =~ ^[Yy]*$ ]]; then \
  git push origin --delete ${feature} &> /dev/null; \
  git branch -d ${feature}; \
else \
  git checkout -; \
fi; \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

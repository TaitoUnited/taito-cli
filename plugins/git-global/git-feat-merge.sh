#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

dest="${taito_branch:-dev}"
feature="feature/${1:?Feature name not given}"

echo "Merging ${feature} to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]$ ]]; then
  exit 130
fi

# diff-index -> Commit only if there is something to commit
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
echo 'Rebase branch ${feature} before merge (Y/n)?' && \
read -r rebase && \
if [[ \${rebase} =~ ^[Yy]$ ]]; then \
  git checkout ${feature} && git rebase -i ${dest} && git checkout -; \
fi && \
git checkout ${dest} && \
git pull && \
git merge ${feature} && \
(git diff-index --quiet HEAD || git commit -v) && \
(
  git push || \
  echo NOTE: Push failed. Fix errors and the run \'git push\'.
) && \
echo 'Delete branch ${feature} (Y/n)?' && \
read -r del && \
if [[ \${del} =~ ^[Yy]$ ]]; then \
  git push origin --delete ${feature} &> /dev/null; \
  git branch -d ${feature}; \
else \
  git checkout -; \
fi; \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"
: "${taito_target_env:?}"

dest="${taito_branch:-dev}"

# diff-index -> Commit only if there is something to commit
"${taito_util_path}/execute-on-host-fg.sh" "
if git rev-parse --is-inside-work-tree &> /dev/null; then
  set -e
  if [[ \"${1}\" ]]; then
    feature=\"feature/${1}\"
  else
    feature=\$(git symbolic-ref --short HEAD)
  fi

  echo \"Merging \${feature} to ${dest}. Do you want to continue (Y/n)?\"
  read -r confirm
  if ! [[ \${confirm} =~ ^[Yy]*$ ]]; then
    exit 130
  fi
  echo \"Rebase branch \${feature} before merge (Y/n)?\"
  read -r rebase
  if [[ \${rebase} =~ ^[Yy]*$ ]]; then
    git fetch --all
    git checkout \${feature}
    git rebase -i origin/${dest}
    git checkout -
  fi
  git checkout ${dest}
  git pull
  git merge --no-ff \${feature}
  (git diff-index --quiet HEAD || git commit -v) && \
  ( \
    git push --no-verify || \
    echo NOTE: Push failed. Fix all errors first. Then push changes to ${dest} branch and delete the \${feature} branch. \
  ) && \
  echo
  echo \"Delete branch \${feature} (Y/n)?\"
  read -r del
  if [[ \${del} =~ ^[Yy]*$ ]]; then
    git push origin --no-verify --delete \${feature} &> /dev/null
    git branch -d \${feature}
  else
    git checkout -
  fi

  if [[ \"${taito_ci_provider:-}\" == \"local\" ]]; then
    echo
    echo ----------------------------------------------------------------------
    echo TIP: Run \\'taito ci run:${taito_target_env}\\' to execute CI/CD locally.
    echo ----------------------------------------------------------------------
    echo
  fi
fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

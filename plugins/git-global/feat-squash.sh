#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

dest="${taito_branch:-dev}"

# diff-index -> Commit only if there is something to commit
"${taito_util_path}/execute-on-host-fg.sh" "\
if git rev-parse --is-inside-work-tree &> /dev/null; then
  set -e
  if [[ \"${1}\" ]]; then
    feature=\"feature/${1}\"
  else
    feature=\$(git symbolic-ref --short HEAD)
  fi

  echo \"Squashing \${feature} to ${dest}. Do you want to continue (Y/n)?\"
  read -r confirm
  if ! [[ \${confirm} =~ ^[Yy]*$ ]]; then
    exit 130
  fi

  git checkout ${dest}
  git pull
  git merge --squash \${feature}
  (git diff-index --quiet HEAD || git commit -v)
  ( \
    git push --no-verify || \
    echo NOTE: Push failed. Fix all errors first. echo Then push changes to ${dest} branch and delete the \${feature} branch. \
  )
  git branch -D \${feature}
  (git push origin --no-verify --delete \${feature} &> /dev/null || :)

  if [[ \"${taito_ci_provider:-}\" == \"local\" ]]; then
    echo
    echo ----------------------------------------------------------------------
    echo TIP: Run \\'taito ci run:${taito_target_env}\\' to execute CI/CD locally.
    echo ----------------------------------------------------------------------
    echo
  fi
fi
" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

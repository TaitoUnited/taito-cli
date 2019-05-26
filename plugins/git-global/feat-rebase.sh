#!/bin/bash -e
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

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

  echo \"Rebasing \${feature} with ${dest}\"
  read -t 1 -n 1000 discard || :
  read -p \"Do you want to continue? [Y/n] \" -n 1 -r confirm
  echo
  if ! [[ \${confirm} =~ ^[Yy]*$ ]]; then
    exit 130
  fi

  git fetch --all
  git checkout \${feature}
  git rebase -i origin/${dest}
  echo TODO git push origin --no-verify --force-with-lease ?
  git checkout -
fi
" && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

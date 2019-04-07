#!/bin/bash -e
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

dest="${taito_branch:-dev}"

# diff-index -> Commit only if there is something to commit
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
if git rev-parse --is-inside-work-tree &> /dev/null; then
  set -e
  if [[ \"${1}\" ]]; then
    feature=\"feature/${1}\"
  else
    feature=\$(git symbolic-ref --short HEAD)
  fi

  echo \"Rebasing \${feature} with ${dest}. Do you want to continue (Y/n)?\"
  read -r confirm
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
"${taito_cli_path}/util/call-next.sh" "${@}"

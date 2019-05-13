#!/bin/bash -e
: "${taito_util_path:?}"

branch=$1
env="${branch/master/prod}"
commit=$(git rev-parse "${branch}")
"${taito_util_path}/execute-on-host-fg.sh" "
  echo \"Do you want to execute CI/CD for ${env} (Y/n)?\"
  read -r confirm
  if ! [[ \${confirm:-y} =~ ^[Yy]*$ ]]; then
    exit 130
  fi
  ./local-ci.sh ${env} ${commit}
"

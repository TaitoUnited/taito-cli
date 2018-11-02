#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

source="${2:-dev}"
dest="${1:?Destination branch name not given}"

source="${source/prod/master}"
dest="${dest/prod/master}"

# TODO duplicate code with git-feat.sh?
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
if ! git checkout ${dest} 2> /dev/null; then \
  echo 'Creating a new branch ${dest} from ${source}. Do you want to continue (Y/n)?' && \
  read -r confirm && \
  if ! [[ \${confirm} =~ ^[Yy]*$ ]]; then \
    echo Cancelled && \
    exit 130; \
  fi && \
  git checkout ${source} && \
  git pull && \
  git checkout -b ${dest} && \
  git push --no-verify -u origin ${dest}; \
else \
  git branch --set-upstream-to=origin/${dest} ${dest}; \
fi" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

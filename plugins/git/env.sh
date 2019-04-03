#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_target_env:?}"

source="${1:-dev}"
source="${source/prod/master}"
dest="${taito_branch:-}"

if [[ ! ${dest} ]]; then
  echo "ERROR: You cannot use the 'local' env with the env command."
  exit 1
fi

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
#!/bin/bash
: "${taito_cli_path:?}"

branch=$(git symbolic-ref --short HEAD)

echo "Try to avoid using this command if you know that there are currently other people"
echo "working on the ${branch} branch. Also note that this command will not push changes"
echo "to the remote branch if your local branch is not up-to-date."
echo
echo "Forcefully erase the latest commit from local and remote ${branch} branch (y/N)?"
read -r confirm
if [[ "${confirm}" =~ ^[Yy]$ ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git reset HEAD^ --hard && git push origin --force-with-lease"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

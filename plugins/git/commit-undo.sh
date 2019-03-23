#!/bin/bash
: "${taito_cli_path:?}"

branch=$(git symbolic-ref --short HEAD)

echo
echo "Try to avoid using this command if it is likely that someone else has already pulled"
echo "or merged your latest commit. In such case using 'commit revert' might be"
echo "a better idea. Also note that this command will not push changes to the remote"
echo "branch if your local branch is not up-to-date."
echo
echo "Forcefully undo the latest commit from local and remote '${branch}' branch (y/N)?"
read -r confirm
if [[ "${confirm}" =~ ^[Yy]$ ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "\
  git reset HEAD^ --soft && git push origin --no-verify --force-with-lease"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

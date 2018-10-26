#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_project_path:?}"

dest="${taito_branch:-dev}"
if [[ ${1} ]]; then
  feature="feature/${1}"
else
  feature=$(git symbolic-ref --short HEAD)
fi

echo "Making a pull request for merging ${feature} \
to ${dest}. Do you want to continue (Y/n)?"
read -r confirm
if ! [[ "${confirm}" =~ ^[Yy]*$ ]]; then
  exit 130
fi

"${taito_cli_path}/util/execute-on-host-fg.sh" "\
echo 'Rebase branch ${feature} before making the pull request (Y/n)?' && \
read -r rebase && \
git checkout ${feature} && \
if [[ \${rebase} =~ ^[Yy]*$ ]]; then \
  git fetch --all && \
  git rebase -i origin/${dest}; \
fi && \
git push --no-verify -u origin ${feature} && \
git checkout - && \
echo && \
echo 'TODO: implement PR using the hub cli.' && \
echo && \
echo 'Make the pull request with your web browser. Press enter to open browser.' && \
read -r && \
taito open-git \
" && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

. _template-config.sh

# Execute create script of template
"${taito_plugin_path}/util/init.sh" "create" && \

rm -f ./_template-config.sh && \

echo "Please wait..." && \
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  export GIT_PAGER="" && \
  git init -q && \
  git add . && \
  git commit -q -m 'First commit' && \
  git remote add origin ${template_dest_git:?}/${taito_repo_name:?}.git && \
  git push -q -u origin master > /dev/null && \
  git tag v0.0.0 && \
  git push -q origin v0.0.0 && \
  git checkout -q -b dev && \
  git push -q -u origin dev > /dev/null && \
  echo DONE! Now configure your project!"

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
#!/bin/bash -e
. _template-config.sh
rm -f _template-config.sh
rm -f taito-config.sh

: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${template_default_source_git:?}"
: "${template_project_path:?}"

function cleanup {
  # Delete temporary template files and configs
  rm -rf ./template-tmp
}
trap cleanup EXIT

# Execute migrate script of template
(
  set -e
  cd "${template_project_path:?}/template-tmp/${template:?}"
  "${taito_plugin_path}/util/init.sh" "migrate"
)

"${taito_util_path}/execute-on-host-fg.sh" "
  if ! git show-ref --tags | grep 'refs/tags/v' &> /dev/null; then
    git tag v0.0.0 && git push -q origin v0.0.0
  fi
"

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

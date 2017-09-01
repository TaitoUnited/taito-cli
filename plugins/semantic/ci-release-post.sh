#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${secret_value_ext_github_build:?}"
: "${taito_project_path:?}"

command=ci-release-post:${taito_env}

# Run the command only if it exists
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  (
    echo
    echo "### npm - release-post: Finalizing release ###"
    echo
    cd "${taito_project_path}/release" || exit 1
    if ! NPM_TOKEN=none GH_TOKEN=${secret_value_ext_github_build} npm run "${command}" -- "${@}"; then
      exit 1
    fi
    rm -f .npmrc
  )
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

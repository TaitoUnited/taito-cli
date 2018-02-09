#!/bin/bash

# NOTE: for backwards compatibility. can be removed later.
if [[ -z "${secret_value_git_github_build}" ]]; then
  secret_value_git_github_build="${secret_value_ext_github_build:-}"
fi

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${secret_value_git_github_build:?}"
: "${taito_project_path:?}"

command=ci-release-post:${taito_env}

# Run the command only if it exists in package.json
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  (
    echo "Finalizing release"
    cd "${taito_project_path}/release" || exit 1
    NPM_TOKEN=none GH_TOKEN=${secret_value_git_github_build} \
      npm run "${command}" -- "${@}" && \
    rm -f .npmrc
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

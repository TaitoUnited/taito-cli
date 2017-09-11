#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"
: "${secret_value_ext_github_build:?}"
: "${taito_project_path:?}"

command=ci-release-pre:${taito_env}

# Run the command only if it exists
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  (
    echo
    echo "### npm - ci-release-pre: Preparing release ###"

    echo "- Cloning git repo to release directory as google container builder"
    echo "workspace does not point to the original repository"
    git clone "https://${secret_value_ext_github_build}@github.com/TaitoUnited/${taito_repo_name}.git" release && \
    cd "${taito_project_path}/release"
    git checkout master && \
    npm install && \

    echo "- Running semantic-release" && \
    NPM_TOKEN=none GH_TOKEN=${secret_value_ext_github_build} \
      npm run "${command}" -- "${@}" && \
    rm -f .npmrc && \

    echo "- Copying package.json with a new version number" && \
    rm -f "${taito_project_path}/package.json" && \
    yes | cp package.json "${taito_project_path}/package.json" && \

    version=$(grep "version" "${taito_project_path}/package.json" | \
      grep -o "[0-9].[0-9].[0-9]") && \
    echo "- New version in ./package.json: ${version}"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

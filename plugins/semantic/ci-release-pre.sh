#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_organization:?}"
: "${taito_repo_name:?}"
: "${secret_value_git_github_build:?}"
: "${taito_project_path:?}"

# NOTE: for backwards compatibility. can be removed later.
if [[ -z "${secret_value_git_github_build}" ]]; then
  secret_value_git_github_build="${secret_value_ext_github_build:-}"
fi

# Determine npm command based on environment
command=release-pre:${taito_env}

# Run the command only if it exists in package.json
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  (
    export NPM_TOKEN
    export GH_TOKEN
    NPM_TOKEN=none
    GH_TOKEN=${secret_value_git_github_build}

    echo "Preparing release"

    # TODO remove hardcoded github.com
    echo "- Cloning git repo to a separate release directory because builder"
    echo "workspace does not necessarily point to the original repository"
    ${taito_setv:?}
    git clone "https://${secret_value_git_github_build}@github.com/${taito_organization}/${taito_repo_name}.git" release && \
    cd "${taito_project_path}/release" && \
    git checkout master && \
    npm install && \

    echo "- Running semantic-release" && \
    echo
    echo "NOTE: Semantic-release will fail if there are no such commits that"
    echo "end up in release notes. By default only 'feat' and 'fix' commits"
    echo "end up there."
    echo
    npm run "${command}" -- "${@}" && \
    rm -f .npmrc && \

    echo "- Copying package.json that contains the new version number" && \
    rm -f "${taito_project_path}/package.json" && \
    yes | cp package.json "${taito_project_path}/package.json" && \
    version=$(grep "version" "${taito_project_path}/package.json" | \
      grep -o "[0-9].[0-9].[0-9]") && \
    echo "- New version in ./package.json: ${version}"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

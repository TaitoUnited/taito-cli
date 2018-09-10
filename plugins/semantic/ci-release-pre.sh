#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_branch:?}"
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
    git checkout ${taito_branch} && \
    npm install && \

    # Required by semantic release?
    npm install eslint mocha && \

    echo "- Running npm script ${command}" && \

    if [[ ${#GH_TOKEN} -lt 8 ]]; then
      echo "WARNING: GH_TOKEN NOT SET!"
    fi && \

    NPM_TOKEN=none GH_TOKEN=${GH_TOKEN} npm run "${command}" -- "${@}" | \
      grep "next release version" | \
      grep -o '[0-9]*\.[0-9]*\.[0-9]*' > ../taitoflag_version && \

    # Support old semantic version (TODO remove support)
    if [[ -s ../taitoflag_version ]]; then
      cat ./package.json | \
        grep -o 'version[": ]*[0-9]*\.[0-9]*\.[0-9]*' | \
        grep -o '[0-9]*\.[0-9]*\.[0-9]*' > ../taitoflag_version &&

      rm -f .npmrc && \
      echo "- Copying package.json that contains the new version number" && \
      rm -f "${taito_project_path}/package.json" && \
      yes | cp package.json "${taito_project_path}/package.json"
    fi
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

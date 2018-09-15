#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_target_env:?}"
: "${taito_branch:?}"
: "${taito_organization:?}"
: "${taito_repo_name:?}"
: "${taito_project_path:?}"

# NOTE: for backwards compatibility. can be removed later.
# NOTE: for backwards compatibility. can be removed later.
if [[ -z "${secret_value_github_buildbot_token:-}" ]]; then
  secret_value_github_buildbot_token="${secret_value_git_github_build:-}"
fi
if [[ -z "${secret_value_github_buildbot_token:-}" ]]; then
  secret_value_github_buildbot_token="${secret_value_ext_github_build:-}"
fi

# Determine npm command based on environment
command=release-pre:${taito_target_env}

# Run the command only if it exists in package.json
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  (
    echo "Preparing release"

    # TODO remove hardcoded github.com
    echo "- Cloning git repo to a separate release directory because builder"
    echo "workspace does not necessarily point to the original repository"
    ${taito_setv:?}
    git clone "https://${secret_value_github_buildbot_token}@github.com/${taito_organization}/${taito_repo_name}.git" release && \
    cd "${taito_project_path}/release" && \
    git checkout ${taito_branch} && \

    # TODO avoid reading secrets to env vars before running npm install
    # TODO is git clone / npm install even necessary with the latest
    # semantic release?
    npm install && \

    echo "- Running npm script ${command}" && \
    NPM_TOKEN=none GH_TOKEN=${secret_value_github_buildbot_token} \
      npm run "${command}" -- "${@}" > ./release-output && \
    cat ./release-output && \

    # Parse version from semantic-release output
    cat ./release-output | \
      grep "next release version" | \
      grep -o '[0-9]*\.[0-9]*\.[0-9]*' > ../taitoflag_version && \

    # Support old semantic version (TODO remove support)
    if [[ ! $(cat ../taitoflag_version) ]]; then
      cat ./package.json | \
        grep -o 'version[": ]*[0-9]*\.[0-9]*\.[0-9]*' | \
        grep -o '[0-9]*\.[0-9]*\.[0-9]*' > ../taitoflag_version && \

      rm -f .npmrc && \
      echo "- Copying package.json that contains the new version number" && \
      rm -f "${taito_project_path}/package.json" && \
      yes | cp package.json "${taito_project_path}/package.json"
    fi && \

    echo "Version: $(cat ../taitoflag_version)"
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

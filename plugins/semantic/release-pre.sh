#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_env:?}"
: "${taito_repo_name:?}"
: "${secret_value_ext_github_build:?}"

command=release-pre:${taito_env}

# Run the command only if it exists
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  if ! (
    echo
    echo "### npm - release-pre: Preparing release ###"
    echo

    echo "- Cloning git repo to release directory as google container builder"
    echo "workspace does not point to the original repository"
    if ! git clone "https://${secret_value_ext_github_build}@github.com/TaitoUnited/${taito_repo_name}.git" release; then
      exit 1
    fi
    cd release
    if ! git checkout master; then # ${commit_sha}
      exit 1
    fi
    if ! npm install; then
      exit 1
    fi

    echo "- Running semantic-release"
    if ! NPM_TOKEN=none GH_TOKEN=${secret_value_ext_github_build} npm run "${command}" -- "${@}"; then
      exit 1
    fi
    rm -f .npmrc

    echo "- Copying package.json with a new version number"
    yes | cp package.json ..
  ); then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

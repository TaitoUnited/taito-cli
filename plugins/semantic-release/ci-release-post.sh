#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_target_env:?}"
: "${taito_project_path:?}"

# NOTE: for backwards compatibility. can be removed later.
if [[ -z "${secret_value_github_buildbot_token:-}" ]]; then
  secret_value_github_buildbot_token="${secret_value_git_github_build:-}"
fi
if [[ -z "${secret_value_github_buildbot_token:-}" ]]; then
  secret_value_github_buildbot_token="${secret_value_ext_github_build:-}"
fi

# Determine npm command based on environment
command=release-post:${taito_target_env}

# Run the command only if it exists in package.json
commands=$(npm run | grep '^  [^ ]*$' | sed -e 's/ //g')
if [[ $(echo "${commands}" | grep "^${command}$") != "" ]]; then
  (
    echo "Finalizing release"
    cd "${taito_project_path}/release" || exit 1
    ${taito_setv:?}
    NPM_TOKEN=none GH_TOKEN=${secret_value_github_buildbot_token} \
      npm run "${command}" -- "${@}" && \
    rm -f .npmrc
  )
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"
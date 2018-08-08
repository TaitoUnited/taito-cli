#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

switches=" ${*} "

# Run clean
if [[ "${switches}" == *" --clean "* ]]; then
  "${taito_plugin_path}/util/clean.sh"
fi && \

# Run npm install
# NOTE: Changed 'npm install' to run on host because of linux permission issues.
# We are installing libs locally anyway so perhaps it is better this way.
# TODO add '--python=${npm_python}' for npm install?
"${taito_util_path}/execute-on-host-fg.sh" "\
  echo \"# Running 'npm install'\" && \
  npm install" && \

# Run postinstall script: install-all, install-ci or install-dev
task_postinstall=""
task_install_ci_exists="$(npm run | grep 'install-ci$')"
task_install_dev_exists="$(npm run | grep 'install-dev$')"
if [[ "${switches}" == *" --all "* ]]; then
  task_postinstall="install-all"
elif [[ "${taito_mode:-}" == "ci" ]] && [[ "${task_install_ci_exists:-}" ]]; then
  task_postinstall="install-ci"
elif [[ "${taito_mode:-}" != "ci" ]] && [[ "${task_install_dev_exists:-}" ]]; then
  task_postinstall="install-dev"
fi && \

if [[ "${task_postinstall}" ]]; then
  # TODO add '--python=${npm_python}' for npm run?
  "${taito_util_path}/execute-on-host-fg.sh" "\
    echo \"# Running 'npm run ${task_postinstall}'\" && \
    npm run ${task_postinstall}"
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

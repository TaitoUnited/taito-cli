#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

switches=" ${*} "
task_install_ci_exists="$(npm run | grep 'install-ci$')"
task_install_dev_exists="$(npm run | grep 'install-dev$')"

if [[ "${switches}" == *" --clean "* ]]; then
  "${taito_plugin_path}/util/clean.sh"
  # echo "Cleaning npm cache" && \
  # (${taito_setv:?}; su taito -s /bin/sh -c 'npm cache clean')
fi && \

# NOTE: Changed 'npm install' to run on host because of linux permission issues.
# We are installing libs locally anyway so perhaps it is better this way.
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  echo \"# Running 'npm install'\" && \
  npm install"


if [[ "${switches}" == *" --all "* ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "\
    echo \"# Running 'npm run install-all'\" && \
    npm run install-all"
elif [[ "${taito_mode:-}" == "ci" ]] && [[ "${task_install_ci_exists:-}" ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "\
    echo \"# Running 'npm run install-dev'\" && \
    npm run install-ci"
elif [[ "${taito_mode:-}" != "ci" ]] && [[ "${task_install_dev_exists:-}" ]]; then
  "${taito_cli_path}/util/execute-on-host-fg.sh" "\
    echo \"# Running 'npm run install-dev'\" && \
    npm run install-dev"
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

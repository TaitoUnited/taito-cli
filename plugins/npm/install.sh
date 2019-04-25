#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"

switches=" ${*} "

# Run postinstall script: install-all, install-ci or install-dev
task_postinstall=""
do_confirm=
task_install_ci_exists="$(npm run | grep 'install-ci$')"
task_install_dev_exists="$(npm run | grep 'install-dev$')"
if [[ "${switches}" == *" --all "* ]]; then
  task_postinstall="install-all"
  do_confirm=true
elif [[ "${taito_mode:-}" == "ci" ]] && [[ "${task_install_ci_exists:-}" ]]; then
  task_postinstall="install-ci"
elif [[ "${taito_mode:-}" != "ci" ]] && [[ "${task_install_dev_exists:-}" ]]; then
  task_postinstall="install-dev"
  do_confirm=true
fi && \

install_all=false
if [[ ${do_confirm} ]] && [[ ! $RUNNING_TESTS ]]; then
  echo
  echo "Install all libraries on host for autocompletion purposes (Y/n)?"
  read -r confirm
  if [[ ${confirm} =~ ^[Yy]*$ ]]; then
    install_all=true
  fi
else
  install_all=true
fi

# Run clean
if [[ "${switches}" == *" --clean "* ]]; then
  "${taito_plugin_path}/util/clean.sh"
fi && \

npm_command="install"
if [[ "${switches}" == *" --lock "* ]]; then
  npm_command="ci"
fi && \

# Run npm install
# NOTE: Changed 'npm install' to run on host because of linux permission issues.
# We are installing libs locally anyway so perhaps it is better this way.
# TODO add '--python=${npm_python}' for npm install?
"${taito_util_path}/execute-on-host-fg.sh" "\
  echo \"# Running 'npm ${npm_command}'\" && \
  npm ${npm_command}" && \

if [[ "${task_postinstall}" ]]; then
  # TODO add '--python=${npm_python}' for npm run?
  "${taito_util_path}/execute-on-host-fg.sh" "
    if [[ ${install_all} == \"true\" ]]; then
      echo \"Running 'npm run ${task_postinstall}'\"
      npm run ${task_postinstall}
    fi
  "
fi && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

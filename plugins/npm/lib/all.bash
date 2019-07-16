#!/bin/bash

function npm::clean () {
  # NOTE: Changed clean to run on host because of linux permission issues.
  # We are installing libs locally anyway so perhaps it is better this way.
  taito::execute_on_host_fg "\
    echo \"Deleting all node_modules directories\"
    find . -name \"node_modules\" -type d -prune -exec rm -rf '{}' +"

  # TODO remove all flow-typed/npm directories also?
}

function npm::install () {
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
  fi

  install_all=false
  if [[ ${taito_mode} != "ci" ]] && [[ ${do_confirm} ]] && [[ ! $RUNNING_TESTS ]]; then
    if taito::confirm \
      "Install all libraries on host for autocompletion purposes?"; then
      install_all=true
    fi
  else
    install_all=true
  fi

  # Run clean
  if [[ "${switches}" == *" --clean "* ]]; then
    "${taito_plugin_path}/util/clean"
  fi

  npm_command="install"
  if [[ "${switches}" == *" --lock "* ]]; then
    npm_command="ci"
  fi

  # Run npm install
  # NOTE: Changed 'npm install' to run on host because of linux permission issues.
  # We are installing libs locally anyway so perhaps it is better this way.
  # TODO add '--python=${npm_python}' for npm install?
  taito::execute_on_host_fg "\
    set -e;
    echo \"Running 'npm ${npm_command}'\"
    npm ${npm_command}"

  if [[ "${task_postinstall}" ]]; then
    # TODO add '--python=${npm_python}' for npm run?
    taito::execute_on_host_fg "
      set -e;
      if [[ ${install_all} == \"true\" ]]; then
        echo \"Running 'npm run ${task_postinstall}'\"
        npm run ${task_postinstall}
      fi
    "
  fi
}

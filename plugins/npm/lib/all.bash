#!/bin/bash

function npm::bin () {
  local npm_bin=npm
  if [[ ${taito_npm_use_yarn} == "true" ]]; then
    npm_bin=yarn
  fi
  echo ${npm_bin}
}

function npm::clean () {
  if npm run | grep 'install-clean$' &> /dev/null; then
    taito::execute_on_host_fg "
      set -e
      echo \"Running '$(npm::bin) run install-clean'\"
      $(npm::bin) run install-clean
    "
  fi

  # NOTE: Changed clean to run on host because of linux permission issues.
  # We are installing libs locally anyway so perhaps it is better this way.
  taito::execute_on_host_fg "\
    echo \"Deleting all package-lock.json files\"
    find . -name \"package-lock.json\" -type f -prune -exec rm -rf '{}' + || :
    echo \"Deleting all node_modules directories\"
    find . -name \"node_modules\" -type d -prune -exec rm -rf '{}' + || :"
}

function npm::install () {
  local switches=" ${*} "

  # Run postinstall script: install-all, install-ci or install-dev
  local task_postinstall=""
  local do_confirm=
  local task_install_ci_exists="$(npm run | grep 'install-ci$')"
  local task_install_dev_exists="$(npm run | grep 'install-dev$')"
  if [[ ${switches} == *" --all "* ]]; then
    task_postinstall="install-all"
    do_confirm=true
  elif [[ ${taito_mode:-} == "ci" ]] && [[ ${task_install_ci_exists:-} ]]; then
    task_postinstall="install-ci"
  elif [[ ${taito_mode:-} != "ci" ]] && [[ ${task_install_dev_exists:-} ]]; then
    task_postinstall="install-dev"
    do_confirm=true
  fi

  local install_all=false
  if [[ ${taito_mode} != "ci" ]] && \
     [[ ${do_confirm} ]] && \
     [[ ! $RUNNING_TESTS ]]
  then
    if taito::confirm \
      "Install all libraries on host for autocompletion purposes?"; then
      install_all=true
    fi
  else
    install_all=true
  fi

  # Run clean
  if [[ ${switches} == *" --clean "* ]]; then
    npm::clean
  fi

  local npm_command="install"
  if [[ ${switches} == *" --lock "* ]]; then
    npm_command="ci"
  fi

  # Run npm install
  # NOTE: Changed 'npm install' to run on host because of linux permission issues.
  # We are installing libs locally anyway so perhaps it is better this way.
  # TODO add '--python=${npm_python}' for npm install?
  taito::execute_on_host_fg "
    set -e
    echo \"Running '$(npm::bin) ${npm_command}'\"
    $(npm::bin) ${npm_command}
  "

  if [[ ${task_postinstall} ]]; then
    npmopts=""
    # TODO: can we avoid using --unsafe-perm?
    if [[ ${taito_mode:-} == "ci" ]] && [[ $(whoami) == "root" ]] && [[ $(npm::bin) == "npm" ]]; then
      npmopts="${npmopts} --unsafe-perm"
    fi

    # TODO add '--python=${npm_python}' for npm run?
    taito::execute_on_host_fg "
      set -e
      if [[ ${install_all} == \"true\" ]]; then
        echo \"Running '$(npm::bin) run ${task_postinstall}'\"
        $(npm::bin) run ${npmopts} ${task_postinstall}
      fi
    "
  fi
}

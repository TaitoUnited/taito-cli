#!/bin/bash -e

taito::confirm () {
  text=${1:-Do you want to continue?}
  default_reply=${2:-yes}
  default_ci=$1

  if [[ $taito_mode == "ci" ]] && [[ $default_ci == "yes" ]]; then
    exit 0
  elif [[ $taito_mode == "ci" ]] && [[ $default_ci == "no" ]]; then
    exit 130
  fi

  if [[ $default_reply == "yes" ]]; then
    prompt="$text [Y/n] "
  else
    prompt="$text [y/N] "
  fi

  # Flush input buffer
  read -r -t 1 -n 1000 || :

  # Display confirm prompt
  read -p "$prompt" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]] || ( \
       [[ $default_reply == "yes" ]] && \
       [[ $REPLY =~ ^[Yy]*$ ]] \
     ); then
    exit 0
  else
    exit 130
  fi
}
export -f taito::confirm

taito::confirm_execution () {
  current_name=${1}
  requested_name=${2}
  prompt=${3}

  if [[ "${requested_name}" == "" ]] || \
     [[ "${requested_name}" == "-"* ]] || \
     [[ "${requested_name}" == "${current_name}" ]]; then
    if [[ "${prompt}" ]]; then
      text="${prompt}?"
    else
      text="Execute ${current_name}?"
    fi
    if taito::confirm "$text"; then exit 0; fi
  fi

  exit 2
}
export -f taito::confirm_execution

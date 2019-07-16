#!/bin/bash -e

taito::open_browser () {
  local url="${1:?}"

  if [[ "${taito_host_uname}" == *"_NT"* ]]; then
    taito::execute_on_host "start chrome '${url}'"
  elif [[ "${taito_host_uname}" == "Darwin" ]]; then
    taito::execute_on_host "open -a 'Google Chrome' '${url}'"
  else
    taito::execute_on_host "xdg-open '${url}'"
  fi
}
export -f taito::open_browser

taito::open_browser_fg () {
  local url="${1:?}"

  if [[ "${taito_host_uname}" == *"_NT"* ]]; then
    taito::execute_on_host_fg \
      "start chrome '${url}'"
  elif [[ "${taito_host_uname}" == "Darwin" ]]; then
    taito::execute_on_host_fg \
      "open -a 'Google Chrome' '${url}'"
  else
    taito::execute_on_host_fg \
      "xdg-open '${url}'"
  fi
}
export -f taito::open_browser_fg

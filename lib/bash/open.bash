#!/bin/bash

function taito::convert_link () {
  url=$1
  if [[ ${taito_host_os:-} == "windows" ]] && [[ ${DOCKER_HOST} ]]; then
    # TODO: DOCKER_HOST contains the host ip? Use it instead of the hard coded
    url="${url/:\/\/localhost/://192.168.99.100}"
  fi
  echo "${url}"
}
export -f taito::convert_link

function taito::open_browser () {
  local url=$(taito::convert_link "${1:?}")

  if [[ ${taito_host_os:-} == "windows" ]]; then
    taito::execute_on_host "start chrome '${url}'"
  elif [[ ${taito_host_os} == "macos" ]]; then
    taito::execute_on_host "open -a 'Google Chrome' '${url}'"
  else
    taito::execute_on_host "xdg-open '${url}'"
  fi
}
export -f taito::open_browser

function taito::open_browser_fg () {
  local url=$(taito::convert_link "${1:?}")

  if [[ ${taito_host_os:-} == "windows" ]]; then
    taito::execute_on_host_fg \
      "start chrome '${url}'"
  elif [[ ${taito_host_os} == "macos" ]]; then
    taito::execute_on_host_fg \
      "open -a 'Google Chrome' '${url}'"
  else
    taito::execute_on_host_fg \
      "xdg-open '${url}'"
  fi
}
export -f taito::open_browser_fg

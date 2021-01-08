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

function taito::print_browser_command () {
  local url=$(taito::convert_link "${1:?}")

  if [[ $url == "https://"* ]] || [[ $url == "http://"* ]]; then
    if [[ ${taito_host_os:-} == "windows" ]]; then
      echo "start '${taito_default_browser:-chrome}' '${url}'"
    elif [[ ${taito_host_os} == "macos" ]]; then
      if [[ $taito_default_browser == "chrome" ]]; then
        echo "open -a 'Google Chrome' '${url}'"
      elif [[ $taito_default_browser ]]; then
        echo "open -a '${taito_default_browser}' '${url}'"
      else
        echo "open '${url}'"
      fi
    else
      echo "${taito_default_browser:-xdg-open} '${url}'"
    fi
  fi
}
export -f taito::print_browser_command

function taito::open_browser () {
  taito::execute_on_host "$(taito::print_browser_command $1)"
}
export -f taito::open_browser

function taito::open_browser_fg () {
  taito::execute_on_host_fg "$(taito::print_browser_command $1)"
}
export -f taito::open_browser_fg

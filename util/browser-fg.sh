#!/bin/bash

# Opens the given url in browser

url="${1:?}"

if [[ "${taito_host_uname}" == "Darwin" ]]; then
  ${taito_cli_path}/util/execute-on-host-fg.sh "open -a 'Google Chrome' '${url}'"
else
  ${taito_cli_path}/util/execute-on-host-fg.sh "xdg-open '${url}'$"
fi

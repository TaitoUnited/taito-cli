#!/bin/bash
# Opens the given url in browser
: "${taito_host_uname:?}"
: "${taito_cli_path:?}"

url="${1:?}"

if [[ "${taito_host_uname}" == *"_NT"* ]]; then
  "${taito_cli_path}/util/execute-on-host.sh" "start chrome '${url}'"
elif [[ "${taito_host_uname}" == "Darwin" ]]; then
  "${taito_cli_path}/util/execute-on-host.sh" "open -a 'Google Chrome' '${url}'"
else
  "${taito_cli_path}/util/execute-on-host.sh" "xdg-open '${url}'"
fi

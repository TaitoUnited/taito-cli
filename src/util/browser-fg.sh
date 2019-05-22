#!/bin/bash
# Opens the given url in browser
: "${taito_host_uname:?}"
: "${taito_util_path:?}"

url="${1:?}"

if [[ "${taito_host_uname}" == *"_NT"* ]]; then
  "${taito_util_path}/execute-on-host-fg.sh" \
    "start chrome '${url}'"
elif [[ "${taito_host_uname}" == "Darwin" ]]; then
  "${taito_util_path}/execute-on-host-fg.sh" \
    "open -a 'Google Chrome' '${url}'"
else
  "${taito_util_path}/execute-on-host-fg.sh" \
    "xdg-open '${url}'"
fi
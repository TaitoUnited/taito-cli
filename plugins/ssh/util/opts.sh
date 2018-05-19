#!/bin/bash
: "${taito_host_uname:?}"

opts=""
if [[ -f "${HOME}/.ssh/config.taito" ]]; then
  opts="-F${HOME}/.ssh/config.taito"
elif [[ "${taito_host_uname}" == "Darwin" ]]; then
  echo
  echo "WARNING! ~/.ssh/config.taito file does not exist! SSH execution will"
  echo "fail if your ~/.ssh/config file contains any macOS specific properties"
  echo "(e.g. UseKeyChain)."
fi
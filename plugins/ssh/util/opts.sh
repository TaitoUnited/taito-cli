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

read -t 1 -n 10000 discard || :
if [[ ! ${taito_ssh_user} ]]; then
  echo
  echo "SSH username has not been set. Set taito_ssh_user environment variable"
  echo "in ./taito-user-config.sh or ~/.taito/taito-config.sh to avoid prompt."
  echo "SSH username:"
  read -r taito_ssh_user
  export taito_ssh_user=${taito_ssh_user}
fi

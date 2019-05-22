#!/bin/bash

commands=$1

use_agent=true
if [[ ${SSH_AUTH_SOCK} ]]; then
  # Already running
  use_agent=false
fi

runner="bash -c"
if [[ ${use_agent} == true ]]; then
  runner="ssh-agent bash -c"
fi

${runner} "${commands} \"\${@}\"" -- "${@:2}"

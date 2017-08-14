#!/bin/bash

: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"
: "${taito_env:?}"

change="${1}"

echo
echo "### postgres - db-revert: Reverting database changes of ${taito_env} ###"
echo

# To avoid accidents, we always require CHANGE as argument
# TODO only revert the "previous batch" of changes when CHANGE is not given
# as argument

if [[ -z "${change}" ]]; then
  echo "Please supply CHANGE as argument"
else
  "${taito_plugin_path}/util/sqitch.sh" revert "${change}" \
    --set env="'${taito_env}'"
  # shellcheck disable=SC2181
  if [[ $? -gt 0 ]]; then
    exit 1
  fi
fi

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

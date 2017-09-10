#!/bin/bash

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.

commands="${1:?}"
sleep_seconds="${2}"

if [[ "${taito_mode:-}" == "ci" ]] || \
   [[ "${taito_mode:-}" == "local" ]]; then
  echo
  echo "### Taito-cli running locally ###"
  echo "${commands}"
  echo
  eval "${commands}"
else
  echo
  echo "### Taito-cli running on host ###"
  echo
  echo "${taito_run:?}${commands}${taito_run:?}"
  echo
  sleep "${sleep_seconds:-2}"
fi

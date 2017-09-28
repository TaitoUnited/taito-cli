#!/bin/bash

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.

commands="${*:1}"
sleep_seconds="${2}"

if [[ "${taito_mode:-}" == "ci" ]] || \
   [[ "${taito_mode:-}" == "local" ]]; then
  eval "${commands}"
  echo
else
  echo "${taito_run:?}${commands}${taito_run:?}"
  echo
  sleep "${sleep_seconds:-2}"
fi

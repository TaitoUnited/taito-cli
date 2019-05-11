#!/bin/bash
: "${taito_vout:?}"
: "${taito_env:?}"

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.

commands="${*:1}"
sleep_seconds="${2}"

echo "+ ${commands}" > "${taito_vout}"

# TODO: clean up this hack (for running docker commands on remote host)
if [[ "${taito_host:-}" ]] && \
   [[ "${taito_env}" != "local" ]] && \
   [[ "${commands}" == *"docker"* ]]; then
  ssh "${taito_ssh_user:?}@${taito_host}" "${commands}"
elif [[ "${taito_mode:-}" == "ci" ]]; then
  echo "RUNNING: ${commands}"
  eval "${commands}"
elif [[ -n ${taito_run:-} ]]; then
  echo "${commands}" >> ${taito_run}
  sleep "${sleep_seconds:-2}"
else
  echo
  echo "-----------------------------------------------------------------------"
  echo "NOTE: On Windows you need to execute these commands manually:"
  echo "${commands}"
  echo "-----------------------------------------------------------------------"
  echo
  echo "Press enter after you have executed all the commands"
  read -r
fi

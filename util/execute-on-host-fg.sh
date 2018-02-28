#!/bin/bash
: "${taito_vout:?}"

# Executes the given shell commands on host
# NOTE: executes in container if ci mode is enabled.

commands="${*:1}"

echo "+ ${commands}" > "${taito_vout}"

if [[ "${taito_mode:-}" == "ci" ]]; then
  eval "${commands}"
elif [[ -n ${taito_run_fg:-} ]]; then
  echo "${commands}" >> ${taito_run_fg}
else
  echo
  echo "-----------------------------------------------------------------------"
  echo "NOTE: On Windows you need to execute these commands manually:"
  echo "${commands}"
  echo "-----------------------------------------------------------------------"
  echo
fi

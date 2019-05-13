#!/bin/bash
: "${taito_util_path:?}"
: "${taito_plugin_path:?}"
: "${taito_command:?}"
: "${run_scripts_location:?}"

# Runs a process if run_for_XXX or run_bg_for_XXX setting is set for one of the
# plugins in the current command chain
. ${taito_plugin_path}/util/run.sh run_bg_for_ run_background_pids
. ${taito_plugin_path}/util/run.sh run_for_

# Run scripts from scripts/run directory
script="${run_scripts_location}/taito-${taito_command}.sh"
if [[ -f ${script} ]]; then
  echo "Running script: ${script}"
  "${script}" "${@}"
fi

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

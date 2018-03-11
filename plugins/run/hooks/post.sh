#!/bin/bash
: "${taito_cli_path:?}"

# Runs a process if run_after_for_XXX setting is set for one of the
# plugins in the current command chain
. ${taito_plugin_path}/util/run.sh run_after_for_

# kill started run processes
for run_pid in ${ssh_background_pids:-}
do
  kill "${run_pid}"
done

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

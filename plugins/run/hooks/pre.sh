#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_plugin_path:?}"

# Runs a process if run_for_XXX or run_bg_for_XXX setting is set for one of the
# plugins in the current command chain
. ${taito_plugin_path}/util/run.sh run_bg_for_ run_background_pids
. ${taito_plugin_path}/util/run.sh run_for_

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"

# Runs a process if ssh_forward_for_XXX setting is set for one of the
# plugins in the current command chain
export ssh_was_run="false"
plugin_suffices=$(env | cut -f1 -d= | grep "ssh_forward_for_" | \
  sed "s/ssh_forward_for_//" | tr '\n' ' ')
for plugin_suffix in ${plugin_suffices[@]}
do
  opts=""
  if [[ -f "${HOME}/.ssh/config.taito" ]]; then
    opts="-F ~/.ssh/config.taito"
  fi
  forward_env_var_name="ssh_forward_for_${plugin_suffix}"
  forward_value="${!forward_env_var_name}"
  eval "export ssh_command_for_${plugin_suffix}=\"ssh ${opts} -4 -f -o ExitOnForwardFailure=yes -L ${forward_value} sleep 10\""
  ssh_was_run="true"
done

. ${taito_cli_path}/plugins/run/util/run.sh ssh_command_for_

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

#!/bin/bash
: "${taito_cli_path:?}"

# Runs a process if ssh_forward_for_XXX setting is set for one of the
# plugins in the current command chain
export ssh_proxy_running="${ssh_proxy_running:-false}"
plugin_suffices=$(env | cut -f1 -d= | grep "ssh_forward_for_" | \
  sed "s/ssh_forward_for_//" | tr '\n' ' ')
for plugin_suffix in ${plugin_suffices[@]}
do
  if [[ $ssh_proxy_running == "false" ]] && \
     [[ ${taito_commands_only_chain:-} == *"${plugin_suffix}/"* ]]; then
    echo
    echo "### ssh/pre"
    . ${taito_plugin_path}/util/opts.sh
    forward_env_var_name="ssh_forward_for_${plugin_suffix}"
    forward_value="${!forward_env_var_name}"
    (
      ${taito_setv:?}
      sh -c "ssh ${opts} -4 -f -o ExitOnForwardFailure=yes ${forward_value} sleep 60"
    ) || (
      echo "SSH connection failed with options ${opts} ${forward_value}."
      echo "Have you set taito_ssh_user in ~/.taito/taito-config.sh or ./taito-user-config.sh?"
      exit 1
    ) && \
    ssh_proxy_running="true"
  fi
done && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

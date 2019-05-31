#!/bin/bash
: "${taito_util_path:?}"

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
    echo -e "${taito_command_context_prefix:-}${H1s}ssh${H1e}"
    . ${taito_plugin_path}/util/opts.sh
    forward_env_var_name="ssh_forward_for_${plugin_suffix}"
    forward_value="${!forward_env_var_name}"
    forward_value=$(echo "$forward_value" | "${taito_util_path}/replace-variables.sh")
    (
      ${taito_setv:?}
      sh -c "ssh ${opts} -4 -f -o ExitOnForwardFailure=yes ${forward_value} sleep 60"
    ) || (
      echo "SSH connection failed with options ${opts} ${forward_value}."
      exit 1
    ) && \
    ssh_proxy_running="true"
  fi
done && \

# Call next command on command chain
"${taito_util_path}/call-next.sh" "${@}"

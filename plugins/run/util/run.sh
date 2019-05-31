#!/bin/bash
: "${taito_vout:?}"

run_env_var_prefix=${1}
run_bg_pids_env_var=${2}

run_bg_temp_pids=""
plugin_suffices=$(env | cut -f1 -d= | grep "${run_env_var_prefix}" | \
  sed "s/${run_env_var_prefix}//" | tr '\n' ' ')
for plugin_suffix in ${plugin_suffices[@]}
do
  if [[ ${taito_commands_only_chain:-} == *"${plugin_suffix}/"* ]]; then
    env_var="${run_env_var_prefix}${plugin_suffix}"
    echo
    echo -e "${taito_command_context_prefix:-}${H1s}run${H1e}"
    echo "Running command: ${!env_var}" > "${taito_vout}"
    if [[ ${run_bg_pids_env_var} ]]; then
      sh -c "${!env_var}" &
      run_bg_temp_pids="${run_bg_temp_pids} $!"
    else
      sh -c "${!env_var}"
    fi
  fi
done

if [[ ${run_bg_pids_env_var} ]]; then
  eval "export ${run_bg_pids_env_var}=${run_bg_temp_pids}"
fi

#!/bin/bash

function run::run () {
  : "${taito_vout:?}"

  local run_env_var_prefix=${1}
  local run_bg_pids_env_var=${2}

  local run_bg_temp_pids
  local env_var
  local run_bg_temp_pids=""
  local plugin_suffix
  local plugin_suffices
  plugin_suffices=$(
    set -o posix; set | \
      cut -f1 -d= | \
      grep "${run_env_var_prefix}" | \
      sed "s/${run_env_var_prefix}//" | tr '\n' ' '
  )
  for plugin_suffix in ${plugin_suffices[@]}
  do
    if [[ ${taito_commands_only_chain:-} == *"${plugin_suffix}/"* ]]; then
      env_var="${run_env_var_prefix}${plugin_suffix}"
      taito::print_plugin_title
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
}

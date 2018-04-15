#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

# Basic commands
echo "--help"
echo "--readme"
echo "--shell"
echo "--trouble"
echo "--upgrade"

# New project from template
echo "template create: TEMPLATE"

# Global links
while IFS='*' read -ra items; do
  for item in "${items[@]}"; do
    words=(${item})
    link="${words[0]}"
    if [[ ${link} ]]; then
      prefix="$( cut -d '=' -f 1 <<< "$link" )";
      command=${prefix%#*}
      echo "open ${command}"
    fi
  done
done <<< "${link_global_urls:-}"

# Passwords
# TODO enable only when available
# echo "passwd share"
# echo "passwd list"
# echo "passwd list: FILTER"
# echo "passwd get: NAME"
# echo "passwd set: NAME"
# echo "passwd rotate"
# echo "passwd rotate: FILTER"

# Zone management
if [[ ${taito_is_zone:-} ]]; then
  echo "zone apply"
  echo "zone status"
  echo "zone doctor"
  echo "zone maintenance"
  echo "zone destroy"
fi

# Project
if [[ ${taito_project:-} ]]; then
  echo "install"
  echo "install --zzzzz" # TODO remove this zsh autocompletion hack
  echo "install --clean"
  echo "env"
  echo "build"
  echo "db add: NAME"
  echo "template upgrade"
  echo "workspace clean"
  echo "workspace kill"

  # Version control commands
  echo "vc env list"
  echo "vc env merge"
  echo "vc feat list"
  echo "vc feat rebase"
  echo "vc feat squash"
  echo "vc feat merge"
  echo "vc feat pr"
  echo "vc feat: FEATURE"
  features=$(git branch -a 2> /dev/null | \
    grep " feature/" | sed -e 's|feature/||')
  for feature in ${features}
  do
    echo "vc feat: ${feature}"
  done

  # Stack component commands
  for stack in ${ci_stack:-}
  do
    echo "clean: ${stack}"
  done

  # Project management
  # NOTE: Advanced
  echo "project apply"
  echo "project destroy"
  echo "project docs"
  echo "project contacts"

  # Environment specific commands
  envs="loc ${taito_environments:-}"
  for env_orig in ${envs}
  do
    env="${env_orig}"
    suffix=":${env}"
    param=":${env}"
    if [[ ${env_orig} == "loc" ]]; then
      env="local"
      suffix=""
      param=":"
    fi

    echo "start${suffix}"
    echo "stop${suffix}"
    # TODO run:ios run:android # Run the application
    echo "init${suffix}"
    echo "init${suffix} --zzzzz" # TODO remove this zsh autocompletion hack
    echo "init${suffix} --clean"
    echo "info${suffix}"
    echo "test${suffix}"
    echo "secrets${suffix}"
    echo "status${suffix}"

    echo "db proxy${suffix}"
    echo "db open${suffix}"
    echo "db import${param}"
    echo "db dump${suffix}"
    echo "db log${suffix}"
    echo "db recreate${suffix}"
    echo "db deploy${suffix}"
    echo "db rebase${suffix}"
    echo "db rebase${param} CHANGE"
    echo "db revert${param} CHANGE"
    echo "db diff${param} SOURCE_ENV"
    echo "db copy${param} SOURCE_ENV"
    echo "db copyquick${param} SOURCE_ENV"

    # Local-only commands
    if [[ "${env}" == "local" ]]; then
      echo "start${suffix} --background"
      echo "start${suffix} --clean"
      echo "start${suffix} --background --clean"
      echo "start${suffix} --clean --background"
      echo "start${suffix} --prod --clean"
      echo "start${suffix} --clean --prod"
      echo "unit${suffix}"
      echo "analyze${suffix}"
      echo "scan${suffix}"
      echo "docs${suffix}"
      echo "lock${suffix}"
    fi

    # Remote-only commands
    if [[ "${env}" != "local" ]]; then
      echo "--auth${suffix}"
      echo "vc env: ${env}"

      # NOTE: Advanced
      echo "env apply${suffix}"
      echo "env rotate${suffix}"
      echo "env destroy${suffix}"
      # echo "env alt apply${suffix}"
      # echo "env alt rotate${suffix}"
      # echo "env alt destroy${suffix}"

      echo "depl deploy${param} IMAGE_TAG"
      echo "depl cancel${suffix}"
      echo "depl revision${suffix}"
      echo "depl revert${param} REVISION"
    fi

    # Stack component commands
    for stack in ${ci_stack}
    do
      echo "test${param} ${stack}"
      echo "test${param} ${stack} SUITE"
      echo "logs${param} ${stack}"
      echo "shell${param} ${stack}"
      echo "exec${param} ${stack} - COMMAND"
      echo "cp${param} ${stack}:PATH PATH"
      echo "cp${param} PATH ${stack}:PATH"
      echo "kill${param} ${stack}"
      echo "depl build${param} ${stack}"
    done

    # Links
    while IFS='*' read -ra items; do
      for item in "${items[@]}"; do
        words=(${item})
        link="${words[0]}"
        if [[ ${link} ]]; then
          prefix="$( cut -d '=' -f 1 <<< "$link" )";
          command=${prefix%#*}
          name=${prefix##*#}
          if [[ "${command}" == *"[:ENV]"* ]]; then
            command_env=${command/\[:ENV\]/$suffix}
            echo "open ${command_env}"
          elif [[ "${command}" == *":ENV"* ]] && \
               [[ "${env_orig}" != "loc" ]]; then
            command_env=${command/:ENV/$suffix}
            echo "open ${command_env}"
          elif [[ "${command}" != *":ENV"* ]] && \
               [[ "${env_orig}" == "loc" ]]; then
            echo "open ${command}"
          fi
        fi
      done
    done <<< "${link_urls:-}"
  done
fi

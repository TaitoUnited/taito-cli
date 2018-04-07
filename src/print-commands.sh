#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

features=$(git branch -a | grep " feature/" | sed -e 's|feature/||')

# TODO advanced commands flag for showing taito zone, --shell etc commands

(
  # Basic commands
  echo "--help"
  echo "--readme"
  echo "--shell"
  echo "--trouble"
  echo "--upgrade"
  echo "install"
  echo "install --clean"
  echo "env"
  echo "build"
  echo "db add: [NAME]"
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
  echo "vc feat: [FEATURE]"
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

  # Zone management
  # TODO: Show only for a zone
  # echo "zone apply"
  # echo "zone status"
  # echo "zone doctor"
  # echo "zone maintenance"
  # echo "zone destroy"

  # Passwords
  echo "passwd share"
  echo "passwd list"
  echo "passwd list: [FILTER]"
  echo "passwd get: [NAME]"
  echo "passwd set: [NAME]"
  echo "passwd rotate"
  echo "passwd rotate: [FILTER]"

  # Environment specific commands
  envs="local ${taito_environments:-}"
  for env in ${envs}
  do
    suffix=""
    if [[ "${env}" != "local" ]]; then
      suffix=":${env}"
    fi

    echo "start${suffix}"
    echo "stop${suffix}"
    # TODO run:ios run:android
    echo "init${suffix}"
    echo "init${suffix} --clean"
    echo "info${suffix}"
    echo "test${suffix}"
    echo "secrets${suffix}"
    echo "status${suffix}"

    echo "db proxy${suffix}"
    echo "db open${suffix}"
    echo "db import${suffix} [FILE]"
    echo "db dump${suffix}"
    echo "db log${suffix}"
    echo "db recreate${suffix}"
    echo "db deploy${suffix}"
    echo "db rebase${suffix}"
    echo "db rebase${suffix} [CHANGE]"
    echo "db revert${suffix} [CHANGE]"
    echo "db diff${suffix} [SOURCE_ENV]"
    echo "db copy${suffix} [SOURCE_ENV]"
    echo "db copyquick${suffix} [SOURCE_ENV]"

    # Local-only commands
    if [[ "${env}" == "local" ]]; then
      echo "start${suffix} --background"
      echo "start${suffix} --background --clean"
      echo "start${suffix} --clean"
      echo "start${suffix} --prod --clean"
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

      echo "depl deploy${suffix} [IMAGE_TAG]"
      echo "depl cancel${suffix}"
      echo "depl revision${suffix}"
      echo "depl revert${suffix} [REVISION]"
    fi

    # Stack component commands
    for stack in ${ci_stack}
    do
      echo "test${suffix} ${stack}"
      echo "test${suffix} ${stack} [SUITE]"
      echo "logs${suffix} ${stack}"
      echo "shell${suffix} ${stack}"
      echo "exec${suffix} ${stack} - [COMMAND]"
      echo "cp${suffix} ${stack}:[PATH] [PATH]"
      echo "cp${suffix} [PATH] ${stack}:[PATH]"
      echo "kill${suffix} ${stack}"
      echo "depl build${suffix} ${stack}"
    done

    # Links
    while IFS='*' read -ra items; do
      for item in "${items[@]}"; do
        words=(${item})
        link="${words[0]}"
        if [[ ${link} ]]; then
          prefix="$( cut -d '=' -f 1 <<< "$link" )";
          command=${prefix%#*}
          if [[ "${command}" == *"[:ENV]"* ]]; then
            command_env=${command/\[:ENV\]/$suffix}
            echo "open ${command_env}"
          elif [[ "${command}" == *":ENV"* ]] && [[ "${env}" != "local" ]]; then
            command_env=${command/:ENV/$suffix}
            echo "open ${command_env}"
          elif [[ "${command}" != *":ENV"* ]] && [[ "${env}" == "local" ]]; then
            echo "open ${command}"
          fi
        fi
      done
    done <<< "${link_global_urls:-} ${link_urls:-}"
  done
) | sort

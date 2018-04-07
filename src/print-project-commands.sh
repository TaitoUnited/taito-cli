#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

features=$(git branch -a | grep " feature/" | sed -e 's|feature/||')

# TODO advanced commands flag for showing taito zone, --shell etc commands

(
  # Basic commands
  echo "--help"
  echo "--upgrade"
  echo "install"
  echo "install --clean"
  echo "db add: [NAME]"
  echo "template upgrade"
  echo "workspace kill"
  echo "workspace clean"

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
    echo "init${suffix}"
    echo "init${suffix} --clean"
    echo "info${suffix}"
    echo "status${suffix}"
    echo "unit${suffix}"
    echo "test${suffix}"
    echo "test${suffix} [SUITE]"

    echo "db open${suffix}"
    echo "db proxy${suffix}"
    echo "db import${suffix} [FILE]"
    echo "db dump${suffix}"
    echo "db log${suffix}"
    echo "db revert${suffix} [CHANGE]"
    echo "db recreate${suffix}"
    echo "db deploy${suffix}"
    echo "db rebase${suffix}"
    echo "db diff${suffix} [SOURCE_ENV]"
    echo "db copy${suffix} [SOURCE_ENV]"

    # Local-only commands
    if [[ "${env}" == "local" ]]; then
      echo "start${suffix} --background"
      echo "start${suffix} --background --clean"
      echo "start${suffix} --clean"
      echo "start${suffix} --prod --clean"
    fi

    # Remote-only commands
    if [[ "${env}" != "local" ]]; then
      echo "--auth${suffix}"
      echo "vc env: ${env}"

      echo "env apply${suffix}"
      echo "env rotate${suffix}"
      echo "env destroy${suffix}"

      echo "depl deploy${suffix} [IMAGE_TAG]"
      echo "depl cancel${suffix}"
      echo "depl revision${suffix}"
      echo "depl revert${suffix} [REVISION]"
    fi

    # Stack component commands
    for stack in ${ci_stack}
    do
      echo "shell${suffix} ${stack}"
      echo "logs${suffix} ${stack}"
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

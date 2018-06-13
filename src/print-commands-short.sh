#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

cprefix="${1:-*}"

# Basic commands
echo "--help"
echo "--readme"
echo "--shell"
echo "--trouble"
echo "--upgrade"
echo "-- COMMANDS"

# Workspace
echo "workspace clean"
echo "workspace kill"

# New project from template
echo "template create: TEMPLATE"

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

# Global links
if [[ ${taito_is_zone:-} ]]; then
  global_links="${link_global_urls:-} ${link_urls:-}"
else
  global_links="${link_global_urls:-}"
fi
if [[ "${cprefix}" == "open"* || "${cprefix}" == "*" ]]; then
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
  done <<< "${global_links:-}"
else
  echo "open"
fi

# Project
if [[ ${taito_project:-} ]]; then
  echo "install"
  echo "install --clean"
  echo "env"
  echo "build"
  echo "db add: NAME"
  echo "template upgrade"

  # Version control commands
  if [[ "${cprefix}" == "vc"* ]] || [[ "${cprefix}" == "*" ]]; then
    echo "vc env list"
    echo "vc env merge"
    echo "vc env merge: SOURCE_BRANCH DESTINATION_BRANCH"
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

    echo "vc pull"
    echo "vc push"
    echo "vc revert"
  else
    echo "vc"
  fi

  # Stack component commands
  for stack in ${taito_targets:-}
  do
    echo "clean:${stack}"
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
    echo "restart${suffix}"
    echo "stop${suffix}"
    # TODO run:ios run:android # Run the application
    echo "init${suffix}"
    echo "init${suffix} --clean"
    echo "info${suffix}"
    echo "test${suffix}"
    echo "secrets${suffix}"
    echo "status${suffix}"

    for database in ${taito_databases:-}
    do
      db=""
      if [[ "${database}" != "database" ]]; then
        db=":${database}"
      fi
      echo "db proxy${db}${suffix}"
      echo "db connect${db}${suffix}"
      echo "db import${db}${param}"
      echo "db dump${db}${suffix}"
      echo "db log${db}${suffix}"
      echo "db recreate${db}${suffix}"
      echo "db deploy${db}${suffix}"
      echo "db rebase${db}${suffix}"
      echo "db rebase${db}${param} CHANGE"
      echo "db revert${db}${param} CHANGE"
      echo "db diff${db}${param} SOURCE_ENV"
      echo "db copy to${db}${param} SOURCE_ENV"
      echo "db copyquick to${db}${param} SOURCE_ENV"
    done

    # Local-only commands
    if [[ "${env}" == "local" ]]; then
      echo "start${suffix} --background"
      echo "start${suffix} --clean"
      echo "start${suffix} --background --clean"
      echo "start${suffix} --clean --background"
      echo "start${suffix} --prod --clean"
      echo "start${suffix} --clean --prod"
      echo "lint${suffix}"
      echo "unit${suffix}"
      echo "unit${suffix} TEST"
      echo "analyze${suffix}"
      echo "scan${suffix}"
      echo "docs${suffix}"
    fi

    # Remote-only commands
    if [[ "${env}" != "local" ]]; then
      echo "--auth${suffix}"
      echo "vc env: ${env}"

      # NOTE: Advanced
      echo "env apply${suffix}"
      echo "env rotate${suffix}"
      echo "env rotate${param} FILTER"
      echo "env destroy${suffix}"
      # echo "alt apply${suffix}"
      # echo "alt rotate${suffix}"
      # echo "alt rotate${param} FILTER"
      # echo "alt destroy${suffix}"

      echo "deployment trigger${suffix}"
      echo "deployment cancel${suffix}"
      echo "deployment deploy${param} IMAGE_TAG"
      echo "deployment revision${suffix}"
      echo "deployment revert${param} REVISION"

      for storage in ${taito_storages:-}
      do
        st=""
        if [[ "${storage}" != "${taito_storages}" ]]; then
          st=":${storage}"
        fi
        echo "storage mount${st}${suffix}"
        echo "storage mount${st}${param} MOUNT_PATH"
        echo "storage copy from${st}${param} DEST_DIR"
        echo "storage copy to${st}${param} SOURCE_DIR"
        echo "storage sync from${st}${param} DEST_DIR"
        echo "storage sync to${st}${param} SOURCE_DIR"
      done
    fi

    # Stack component commands
    for stack in ${taito_targets}
    do
      if [[ "${env}" == "local" ]]; then
        echo "unit:${stack}${suffix}"
        echo "unit:${stack}${param} TEST"
      fi
      echo "test:${stack}${suffix}"
      if [[ "${cprefix}" == "test"* || "${cprefix}" == "*" ]]; then
        suites=($(cat "./${stack}/test-suites" 2> /dev/null)) && \
        for suite in "${suites[@]}"
        do
          echo "test:${stack}${param} ${suite}"
          echo "test:${stack}${param} ${suite} TEST"
        done
      fi
      echo "restart:${stack}${suffix}"
      echo "logs:${stack}${suffix}"
      echo "shell:${stack}${suffix}"
      echo "exec:${stack}${param} COMMAND"
      echo "copy to:${stack}${param} SOURCE_PATH DESTINATION_PATH"
      echo "copy from:${stack}${param} SOURCE_PATH DESTINATION_PATH"
      echo "kill:${stack}${suffix}"
      echo "deployment build:${stack}${suffix}"
    done

    # Links
    if [[ "${cprefix}" == "open"* || "${cprefix}" == "*" ]]; then
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
    fi
  done
fi

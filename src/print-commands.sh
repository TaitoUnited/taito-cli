#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

cprefix="${1:-*}"

# Basic commands
echo "--help \
  &focus \
  # Show help.txt of current project and a list of all taito-cli commands"
echo "--readme \
  &focus \
  # Show README.md of current project and taito-cli"
echo "--shell \
  &focus \
  # Start interactive shell on the taito-cli container"
echo "--trouble \
  &focus \
  # Show trouble.txt of current project and taito-cli"
echo "--upgrade \
  # Upgrade taito-cli and its extensions to the latest version"
echo "-- COMMANDS \
  # Run commands inside the taito-cli container"

# Workspace
echo "workspace clean \
  # Remove all unused build artifacts (e.g. images)"
echo "workspace kill \
  # Kill all running processes (e.g. containers)"

# New project from template
echo "template create: TEMPLATE \
  &focus \
  # Create a project based on a template"

# Passwords
# TODO: enable only if available
# echo "passwd share \
#   # Share a password using a one-time magic link"
# echo "passwd list \
#   # List all passwords"
# echo "passwd list: FILTER \
#   # Search for passwords"
# echo "passwd get: NAME \
#   # Get a password"
# echo "passwd set: NAME \
#   # Set a password"
# echo "passwd rotate \
#   &focus \
#   # Rotate all passwords"
# echo "passwd rotate: FILTER \
#   &focus \
#   # Rotate some passwords"

# Zone management
if [[ ${taito_is_zone:-} ]]; then
  echo "zone apply # Apply infrastructure changes to the zone"
  echo "zone status # Show status summary of the zone"
  echo "zone doctor # Analyze and repair the zone"
  echo "zone maintenance # Execute maintenance tasks interactively"
  echo "zone destroy # Destroy the zone"
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
        name=${prefix##*#}
        echo "open ${command} \
          # Open ${name} in browser"
      fi
    done
  done <<< "${global_links:-}"
else
  echo "open"
fi

# Project
if [[ ${taito_project:-} ]]; then
  echo "install \
    # Install libraries on host"
  echo "install --clean \
    # Install libraries on host"
  echo "env \
    # Initialize shell environment (e.g. pipenv)"
  echo "build \
    # Build project"
  echo "db add: NAME \
    # Add a database migration"
  echo "template upgrade \
    # Upgrade project using template"

  # Version control commands
  if [[ "${cprefix}" == "vc"* ]] || [[ "${cprefix}" == "*" ]]; then
    echo "vc env list \
      # List all environment branches"
    echo "vc env merge \
      # Merge current env branch to the next env branch"
    echo "vc env merge: SOURCE_BRANCH DESTINATION_BRANCH \
      # Merge source env branch to the destination env branch"
    echo "vc feat list \
      # List all feature branches"
    echo "vc feat rebase \
      # Rebase feature branch with the original branch"
    echo "vc feat squash \
      # Squash feature branch as a single commit"
    echo "vc feat merge \
      &focus \
      # Merge current feature branch to the original"
    echo "vc feat pr \
      # Create a pull-request for current feature branch"
    echo "vc feat: FEATURE \
      # Switch to a feature branch"
    echo "vc pull \
      # Pull changes"
    echo "vc push \
      # Push changes"
    echo "vc revert \
      # Revert latest commit from local and remote repo"

  else
    echo "vc"
  fi

  features=$(git branch -a 2> /dev/null | \
    grep " feature/" | sed -e 's|feature/||')
  for feature in ${features}
  do
    echo "vc feat: ${feature} \
      # Switch to the ${feature} feature branch"
  done

  # Stack component commands
  for stack in ${taito_targets:-}
  do
    echo "clean:${stack} \
      # Clean ${stack} image (NOTE: run 'taito stop' first)"
  done

  # Project management
  # NOTE: Advanced
  echo "project apply \
    # Migrate project to the latest configuration"
  echo "project destroy \
    # Destroy project"
  echo "project docs \
    # Populate taito settings to project documentation"
  echo "project contacts \
    # List project contacts"

  # Environment specific commands
  envs="loc local ${taito_environments:-}"
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

    echo "start${suffix} \
      # Start app / watch on ${env} environment"
    echo "restart${suffix} \
      # Restart app / watch on ${env} environment"
    echo "stop${suffix} \
      # Stop app / watch on ${env} environment"
    # TODO run:ios run:android # Run the application
    echo "init${suffix} \
      # Initialize database and storage buckets on ${env} environment"
    echo "init${suffix} --clean \
      &focus \
      # Clean and renitialize database and storage buckets on ${env} environment"
    echo "info${suffix} \
      # Show info required for logging in to app on ${env} environment"
    echo "test${suffix} \
      # Run integration and e2e tests on ${env} environment"
    echo "secrets${suffix} \
      # Show secrets of ${env} environment"
    echo "status${suffix} \
      # Show application status of ${env} environment"

    for database in ${taito_databases:-}
    do
      db=""
      if [[ "${database}" != "database" ]]; then
        db=":${database}"
      fi
      echo "db proxy${db}${suffix} \
        # Show db conn details for ${env} environment and start a proxy if required"
      echo "db connect${db}${suffix} \
        &focus \
        # Open database client for ${env} environment from command line"
      echo "db import${db}${param} FILE \
        # Import a file to database on ${env} environment"
      echo "db dump${db}${suffix} \
        # Dump database of ${env} environment to a file"
      echo "db log${db}${suffix} \
        # View change log of ${env} environment database"
      echo "db recreate${db}${suffix} \
        # Recreates the ${env} environment database"
      echo "db deploy${db}${suffix} \
        # Deploy changes to ${env} environment database"
      echo "db rebase${db}${suffix} \
        # Rebases ${env} environment database by running 'db revert' and then 'db deploy'"
      echo "db rebase${db}${param} CHANGE \
        # Rebases ${env} environment database by running 'db revert' and then 'db deploy'"
      echo "db revert${db}${param} CHANGE \
        # Revert ${env} environment database changes"
      echo "db diff${db}${param} SOURCE_ENV \
        # Compare (diff) source env database schema with ${env} environment"
      echo "db copy to${db}${param} SOURCE_ENV \
        # Copy database from source env to ${env} environment"
      echo "db copyquick to${db}${param} SOURCE_ENV \
        # Copy database quickly from source env to ${env} environment (WARNING!!)"
    done

    # Local-only commands
    if [[ "${env}" == "local" ]]; then
      echo "start${suffix} --background \
        # Start containers in background"
      echo "start${suffix} --background --clean \
        # Clean and start containers in background"
      echo "start${suffix} --clean \
        # Clean and start containers"
      echo "start${suffix} --prod --clean \
        # Clean and start containers in production mode"
      echo "lint${suffix} \
        # Lint code"
      echo "unit${suffix} \
        # Run all unit tests"
      echo "unit${suffix} TEST \
        # Run an unit test"
      echo "check size${suffix} \
        # Check size"
      echo "check deps${suffix} \
        # Check dependencies"
      echo "docs${suffix} \
        # Generate documentation"
    fi

    # Remote-only commands
    if [[ "${env}" != "local" ]]; then
      echo "--auth${suffix} \
        &focus \
        # Authenticate for the ${env} environment"
      echo "vc env: ${env} \
        # Switch to the ${env} environment branch"

      # NOTE: Advanced
      echo "env apply${suffix} \
        &focus \
        # Apply project specific changes to ${env} environment"
      echo "env rotate${suffix} \
        &focus \
        # Rotate project specific secrets in ${env} environment"
      echo "env rotate${param} FILTER \
        &focus \
        # Rotate project specific secrets in ${env} environment"
      echo "env destroy${suffix} \
        &focus \
        # Destroy the ${env} environment of the current project"
      # echo "alt apply${suffix}"
      # echo "alt rotate${suffix}"
      # echo "alt rotate${param} FILTER"
      # echo "alt destroy${suffix}"

      echo "deployment trigger${suffix} \
        # Trigger ci build for ${env} environment"
      echo "deployment cancel${suffix} \
        # Cancel an ongoing build for ${env} environment"
      echo "deployment deploy${param} IMAGE_TAG \
        # Deploy prebuilt version to ${env} environment"
      echo "deployment revision${suffix} \
        # Show current revision of ${env} environment"
      echo "deployment revert${param} REVISION \
        # Revert application on ${env} environment to an another revision"

      for storage in ${taito_storages:-}
      do
        st=""
        if [[ "${storage}" != "${taito_storages}" ]]; then
          st=":${storage}"
        fi
        echo "storage mount${st}${suffix} \
          # Mount dev storage bucket to ./mnt/BUCKET"
        echo "storage mount${st}${param} MOUNT_PATH \
          # Mount dev storage bucket to MOUNT_PATH"
        echo "storage copy from${st}${param} DEST_DIR \
          # Copy files from dev bucket to DEST_DIR "
        echo "storage copy to${st}${param} SOURCE_DIR \
          # Copy files from SOURCE_DIR to dev bucket"
        echo "storage sync from${st}${param} DEST_DIR \
          # Sync files from dev bucket to DEST_DIR"
        echo "storage sync to${st}${param} SOURCE_DIR \
          # Sync files from SOURCE_DIR to dev bucket"
      done
    fi

    # Stack component commands
    for stack in ${taito_targets}
    do
      if [[ "${env}" == "local" ]]; then
        echo "unit:${stack}${suffix} \
          # Run all unit tests"
        echo "unit:${stack}${param} TEST \
          # Run an unit test"
      fi
      echo "test:${stack}${suffix} \
        # Run all integration and e2e tests of the ${stack} container on ${env} environment"
      if [[ "${cprefix}" == "test"* || "${cprefix}" == "*" ]]; then
        suites=($(cat "./${stack}/test-suites" 2> /dev/null)) && \
        for suite in "${suites[@]}"
        do
          echo "test:${stack}${param} ${suite} \
            # Run an integration or e2e test suite of the ${stack} container on ${env} environment"
          echo "test:${stack}${param} ${suite} TEST \
            # Run a test of an integration or e2e test suite of the ${stack} container on ${env} environment"
        done
      fi

      echo "restart:${stack}${suffix} \
        # Restart the ${stack} container running on ${env} environment"
      echo "logs:${stack}${suffix} \
        # Tail logs of the ${stack} container running on ${env} environment"
      echo "shell:${stack}${suffix} \
        &focus \
        # Start shell inside the ${stack} container running on ${env} environment"
      echo "exec:${stack}${param} COMMAND \
        # Execute a command in the ${stack} container running on ${env} environment"
      echo "copy to:${stack}${param} SOURCE_PATH DESTINATION_PATH \
        # Copy a file from the ${stack} container running on ${env} environment"
      echo "copy from:${stack}${param} SOURCE_PATH DESTINATION_PATH \
        # Copy a file to the ${stack} container running on ${env} environment"
      echo "kill:${stack}${suffix} \
        # Kill the ${stack} container running on ${env} environment"
      echo "deployment build:${stack}${suffix} \
        # Build and deploy the ${stack} container to ${env} environment"
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
              echo "open ${command_env} \
                # Open ${env} environment ${name} in browser"
            elif [[ "${command}" == *":ENV"* ]] && \
                 [[ "${env_orig}" != "loc" ]]; then
              command_env=${command/:ENV/$suffix}
              echo "open ${command_env} \
                # Open ${env} environment ${name} in browser"
            elif [[ "${command}" != *":ENV"* ]] && \
                 [[ "${env_orig}" == "loc" ]]; then
              echo "open ${command} \
                # Open ${name} in browser"
            fi
          fi
        done
      done <<< "${link_urls:-}"
    fi
  done
fi

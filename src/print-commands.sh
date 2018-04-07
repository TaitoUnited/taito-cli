#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

features=$(git branch -a | grep " feature/" | sed -e 's|feature/||')

(
  # Basic commands
  echo "--help \
    # Show help.txt of current project and a list of all taito-cli commands"
  echo "--readme \
    # Show README.md of current project and taito-cli"
  echo "--shell \
    # Start interactive shell on the taito-cli container"
  echo "--trouble \
    # Show trouble.txt of current project and taito-cli"
  echo "--upgrade \
    # Upgrade taito-cli and its extensions to the latest version"
  echo "install \
    # Install libraries on host"
  echo "install --clean \
    # Install libraries on host"
  echo "env \
    # Initialize shell environment (e.g. pipenv)"
  echo "build \
    # Build project"
  echo "db add: [NAME] \
    # Add a database migration"
  echo "template create: [TEMPLATE] \
    # Create a project based on a template"
  echo "template upgrade \
    # Upgrade project using template"
  echo "workspace clean \
    # Remove all unused build artifacts (e.g. images)"
  echo "workspace kill \
    # Kill all running processes (e.g. containers)"

  # Version control commands
  echo "vc env list \
    # List all environment branches"
  echo "vc env merge \
    # Merge current env branch to the next env branch"
  echo "vc feat list \
    # List all feature branches"
  echo "vc feat rebase \
    # Rebase feature branch with the original branch"
  echo "vc feat squash \
    # Squash feature branch as a single commit"
  echo "vc feat merge \
    # Merge current feature branch to the original"
  echo "vc feat pr \
    # Create a pull-request for current feature branch"
  echo "vc feat: [FEATURE] \
    # Switch to a feature branch"
  for feature in ${features}
  do
    echo "vc feat: ${feature} \
      # Switch to the ${feature} feature branch"
  done

  # Stack component commands
  for stack in ${ci_stack:-}
  do
    echo "clean: ${stack} \
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

  # Zone management
  # TODO: Show only for a zone
  # echo "zone apply # Apply infrastructure changes to the zone"
  # echo "zone status # Show status summary of the zone"
  # echo "zone doctor # Analyze and repair the zone"
  # echo "zone maintenance # Execute maintenance tasks interactively"
  # echo "zone destroy # Destroy the zone"

  # Passwords
  echo "passwd share \
    # Share a password using a one-time magic link"
  echo "passwd list \
    # List all passwords"
  echo "passwd list: [FILTER] \
    # Search for passwords"
  echo "passwd get: [NAME] \
    # Get a password"
  echo "passwd set: [NAME] \
    # Set a password"
  echo "passwd rotate \
    # Rotate all passwords"
  echo "passwd rotate: [FILTER] \
    # Rotate some passwords"

  # Environment specific commands
  envs="local ${taito_environments:-}"
  for env in ${envs}
  do
    suffix=""
    param=":"
    if [[ "${env}" != "local" ]]; then
      suffix=":${env}"
      param=":${env}"
    fi

    echo "start${suffix} \
      # Start app / watch"
    echo "stop${suffix} \
      # Stop app / watch"
    # TODO run:ios run:android # Run the application
    echo "init${suffix} \
      # Initialize database and storage buckets"
    echo "init${suffix} --clean \
      # Initialize database and storage buckets"
    echo "info${suffix} \
      # Show info required for logging in to app"
    echo "test${suffix} \
      # Run integration and e2e tests"
    echo "secrets${suffix} \
      # Show secrets"
    echo "status${suffix} \
      # Show application status"

    echo "db proxy${suffix} \
      # Show db conn details and start a proxy if required"
    echo "db open${suffix} \
      # Access database from command line"
    echo "db import${param} [FILE] \
      # Import a file to database"
    echo "db dump${suffix} \
      # Dump database to a file"
    echo "db log${suffix} \
      # View change log of database"
    echo "db recreate${suffix} \
      # Recreates the database"
    echo "db deploy${suffix} \
      # Deploy changes to database"
    echo "db rebase${suffix} \
      # Rebases database by running 'db revert' and then 'db deploy'"
    echo "db rebase${param} [CHANGE] \
      # Rebases database by running 'db revert' and then 'db deploy'"
    echo "db revert${param} [CHANGE] \
      # Revert database changes"
    echo "db diff${param} [SOURCE_ENV] \
      # Compare database schemas of two environments"
    echo "db copy${param} [SOURCE_ENV] \
      # Copy database from one environment to another"
    echo "db copyquick${param} [SOURCE_ENV] \
      # Copy database quickly from one environent to another (WARNING!!)"

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
      echo "unit${suffix} \
        # Run unit tests"
      echo "analyze${suffix} \
        # Analyze implementation"
      echo "scan${suffix} \
        # Lint code, check code complexity, etc"
      echo "docs${suffix} \
        # Generate documentation"
      echo "lock${suffix} \
        # Lock libraries"
    fi

    # Remote-only commands
    if [[ "${env}" != "local" ]]; then
      echo "--auth${suffix} \
        # Authenticate for the ${env} environment"
      echo "vc env: ${env} \
        # Switch to the ${env} environment branch"

      # NOTE: Advanced
      echo "env apply${suffix} \
        # Apply project specific changes to ${env} env"
      echo "env rotate${suffix} \
        # Rotate project specific secrets in ${env} env"
      echo "env destroy${suffix} \
        # Destroy the ${env} environment of the current project"
      # echo "env alt apply${suffix}"
      # echo "env alt rotate${suffix}"
      # echo "env alt destroy${suffix}"

      echo "depl deploy${param} [IMAGE_TAG] \
        # Deploy prebuilt version to ${env} env"
      echo "depl cancel${suffix} \
        # Cancel an ongoing build for ${env} env"
      echo "depl revision${suffix} \
        # Show current revision of ${env} env"
      echo "depl revert${param} [REVISION] \
        # Revert application on ${env} env to another revision"
    fi

    # Stack component commands
    for stack in ${ci_stack}
    do
      echo "test${param} ${stack} \
        # Run integration and e2e tests"
      echo "test${param} ${stack} [SUITE] \
        # Run an integration or e2e test suite"
      echo "logs${param} ${stack} \
        # Tail logs of a container named ${stack}"
      echo "shell${param} ${stack} \
        # Start shell inside a container named ${stack}"
      echo "exec${param} ${stack} - [COMMAND] \
        # Execute a command in a container"
      echo "cp${param} ${stack}:[PATH] [PATH] \
        # Copy a file from a container"
      echo "cp${param} [PATH] ${stack}:[PATH] \
        # Copy a file to a container"
      echo "kill${param} ${stack} \
        # Kill a container named ${stack}"
      echo "depl build${param} ${stack} \
        # Build and deploy ${stack} container to ${env} env"
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
            echo "open ${command_env} \
              # Open ${env} environment ${name} in browser"
          elif [[ "${command}" == *":ENV"* ]] && [[ "${env}" != "local" ]]; then
            command_env=${command/:ENV/$suffix}
            echo "open ${command_env} \
              # Open ${env} environment ${name} in browser"
          elif [[ "${command}" != *":ENV"* ]] && [[ "${env}" == "local" ]]; then
            echo "open ${command} \
              # Open ${name} in browser"
          fi
        fi
      done
    done <<< "${link_global_urls:-} ${link_urls:-}"
  done
) | sort

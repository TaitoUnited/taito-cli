#!/usr/bin/env bash
# NOTE: This bash script is run directly on host.

# TODO refactor: this is duplicate code with autocomplete.sh

cprefix="${1:-*}"

# Basic commands
echo "--help \
  &focus \
  # Show help.txt of current project and a list of all taito-cli commands"
echo "--readme \
  &focus \
  # Show README.md of current project and taito-cli"
echo "shell \
  &focus \
  # Start interactive shell on the taito-cli container"
echo "--trouble \
  &focus \
  # Show trouble.txt of current project and taito-cli"
echo "upgrade \
  # Upgrade taito-cli and its extensions to the latest version"
echo "-- COMMANDS \
  # Run commands inside the taito-cli container"

# Workspace
echo "workspace clean \
  # Remove all unused build artifacts (e.g. images)"
echo "workspace kill \
  # Kill all running processes (e.g. containers)"

# New project from template
echo "project create: TEMPLATE \
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

# Project management
echo "issue auth \
  # Authenticate to the issue management system"
echo "issue add: TITLE - LABELS \
  # Add new issue"
echo "issue status: TITLE - STATUS - PERSON \
  # Change issues status and optionally assign it another person"
echo "issue comment: TITLE \
  # Comment on issue"
echo "issue open: TITLE \
  # Open issue on browser"
echo "issue list: LANE \
  # List open issues by issue board lane"
echo "issue list: LABEL \
  # List open issues by issue label"

# Hours
echo "hours auth \
  # Authenticate to the hour reporting system"
echo "hours start \
  # Start timing hours"
echo "hours pause \
  # Pause timing hours"
echo "hours stop \
  # Stop timing hours and create an hour entry"
echo "hours stop: DESCRIPTION \
  # Stop timing hours and create an hour entry"
echo "hours add: HOURS \
  # Add an hour entry for today"
weekdays="today yesterday mon tue wed thu fri sat sun"
for weekday in ${weekdays}
do
  echo "hours add: HOURS ${weekday} \
    # Add an hour entry for ${weekday}"
  echo "hours add: HOURS ${weekday} \
    # Add an hour entry for ${weekday} DESCRIPTION"
done
echo "hours list \
  # List all hour entries of current project for this month"
echo "hours list: all \
  # List all hour entries of all projects for this month"
echo "hours summary \
  # Show hour summary for this month"
time_intervals="this-month last-month this-week last-week"
for time_interval in ${time_intervals}
do
  echo "hours summary: ${time_interval} \
    # Show hour summary for ${time-interval}"
done

# Zone management
echo "zone create: TEMPLATE # Create a new zone based in an infrastructure template"
if [[ ${taito_type:-} == "zone" ]]; then
  echo "zone apply # Apply infrastructure changes to the zone"
  echo "zone status # Show status summary of the zone"
  echo "zone doctor # Analyze and repair the zone"
  echo "zone maintenance # Execute maintenance tasks interactively"
  echo "zone destroy # Destroy the zone"
fi

# Global links
if [[ ${taito_type:-} == "zone" ]]; then
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
  echo "env \
    # Initialize shell environment (e.g. pipenv)"
  echo "db add: NAME \
    # Add a database migration"
  echo "project upgrade \
    # Upgrade project using template"

  # Version control commands
  echo "conventions \
    # Display version control conventions"
  echo "env list \
    # List all environment branches"
  echo "env merge \
    # Merge current env branch to the next env branch"
  echo "feat list \
    # List all feature branches"
  echo "feat rebase \
    # Rebase feature branch with the original branch"
  echo "feat squash \
    # Squash feature branch as a single commit"
  echo "feat merge \
    &focus \
    # Merge current feature branch to the original"
  echo "feat pr \
    # Create a pull-request for current feature branch"
  echo "feat: FEATURE \
    # Switch to a feature branch"
  echo "pull \
    # Pull changes"
  echo "push \
    # Push changes"
  echo "commit revert \
    # Revert the latest commit by creating a new commit"
  echo "commit undo \
    # Undo the latest commit from local and remote branch. Leave local files untouched."
  echo "commit erase \
    # Erase the latest commit from local and remote branch."
  if [[ "${cprefix}" == "feat"* ]]; then
  features=$(git branch -a 2> /dev/null | \
    grep " feature/" | sed -e 's|feature/||')
  for feature in ${features}
  do
    echo "feat: ${feature} \
      # Switch to the ${feature} feature branch"
  done
  fi

  # Build target commands
  echo "build \
    # Build all"
  for stack in ${taito_build_targets:-}
  do
    echo "build:${stack} \
      # Build ${stack} module"
    echo "save:${stack} \
      # Save changes to ${stack} module"
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
    param_not_empty=":${env}"
    if [[ ${env_orig} == "loc" ]]; then
      env="local"
      suffix=""
      param=":"
      param_not_empty=":local"
    fi

    echo "config${suffix} \
      # Show configuration values"

    echo "env merge${suffix} DESTINATION_BRANCH \
      # Merge source env branch to the destination env branch"

    echo "env apply${suffix} \
      &focus \
      # Apply project specific changes to ${env} environment"
    if [[ "${env}" == "local" ]]; then
      # TOOD: Handle all option permutations nicely
      echo "env apply${suffix} --clean \
        &focus \
        # Clean and apply changes to ${env} environment"
      echo "env apply${suffix} --clean --start \
        &focus \
        # Clean and apply changes to ${env} environment, start"
      echo "env apply${suffix} --clean --start --init \
        &focus \
        # Clean and apply changes to ${env}, start and initialize"
      echo "env apply${suffix} --start \
        &focus \
        # Apply changes to ${env} environment, start"
      echo "env apply${suffix} --start --init \
        &focus \
        # Apply changes to ${env}, start and initialize"
    fi
    echo "env rotate${suffix} \
      &focus \
      # Rotate project specific secrets in ${env} environment"
    echo "env rotate${param} FILTER \
      &focus \
      # Rotate project specific secrets in ${env} environment"
    echo "env destroy${suffix} \
      &focus \
      # Destroy the ${env} environment of the current project"

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

    if [[ "${cprefix}" == "db"* ]] || [[ "${cprefix}" == "*" ]]; then
      for database in $("$taito_util_path/get-targets-by-type.sh" database)
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
        echo "db dump${db}${suffix} FILE \
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
        for dest_env in ${taito_environments/$env/}; do
          echo "db copy between${db}${param_not_empty}:${dest_env} \
            # Copy database from ${env} environment to ${dest_env}"
          echo "db copyquick between${db}${param_not_empty}:${dest_env} \
            # Copy database quickly from ${env} environment to ${dest_env} (WARNING!!)"
        done
      done
    fi

    # Local-only commands
    if [[ "${env}" == "local" ]]; then
      echo "kaboom${suffix} \
        # Start application in a cleaned and initialized local environment with a single command"
      echo "start${suffix} --background \
        # Start containers in background"
      echo "start${suffix} --clean \
        # Clean and start containers"
      echo "start${suffix} --init \
        # Run 'taito init' after start"
      echo "start${suffix} --clean --init \
        # Clean, start and init containers"
      echo "start${suffix} --clean --init --prod \
        # Clean, start and init production containers"
      echo "start${suffix} --background --clean \
        # Clean and start containers in background"
      echo "start${suffix} --clean --prod \
        # Clean and start production containers"
      echo "lint${suffix} \
        # Lint code"
      echo "unit${suffix} \
        # Run all unit tests"
      echo "unit${suffix} TEST \
        # Run an unit test"
      echo "check deps${suffix} \
        # Check dependencies"
      echo "check code${suffix} \
        # check code quality"
      echo "check size${suffix} \
        # Check size"
      echo "docs${suffix} \
        # Generate documentation"
    fi

    # Remote-only commands
    if [[ "${env}" != "local" ]]; then
      echo "auth${suffix} \
        &focus \
        # Authenticate for the ${env} environment"
      echo "env:${env} \
        # Switch to the ${env} environment branch"

      echo "deployment start${suffix} \
        # Trigger ci build for ${env} environment"
      echo "deployment cancel${suffix} \
        # Cancel an ongoing build for ${env} environment"
      echo "deployment deploy${suffix} \
        # Deploy latest built version of ${env} to ${env} environment"
      echo "deployment deploy${param} IMAGE_TAG \
        # Deploy prebuilt IMAGE_TAG version to ${env} environment"
      echo "deployment wait${suffix} \
        # Wait for deployment to ${env} succeed"
      echo "deployment verify${suffix} \
        # Verify deployment of ${env} environment by test results. Revert if required."
      echo "deployment revisions${suffix} \
        # Show current revision of ${env} environment"
      echo "deployment revert${param} REVISION \
        # Revert application on ${env} environment to an another revision"

      echo "build prepare${suffix} \
        # Prepare artifacts for ${env} environment"
      echo "build publish${suffix} \
        # Publish artifacts for ${env} environment"
      if [[ "${env}" == "prod" ]]; then
        echo "build release${suffix} \
          # Release artifacts for ${env} environment"
      fi

      if [[ "${cprefix}" == "storage"* ]] || [[ "${cprefix}" == "*" ]]; then
        for storage in ${taito_storages:-}
        do
          st=""
          if [[ "${storage}" != "${taito_storages}" ]]; then
            st=":${storage}"
          fi
          echo "storage mount${st}${suffix} \
            # Mount ${env} storage bucket to ./mnt/BUCKET"
          echo "storage mount${st}${param} MOUNT_PATH \
            # Mount ${env} storage bucket to MOUNT_PATH"
          echo "storage copy from${st}${param} SOURCE LOCAL_DEST \
            # Copy files from ${env} to local disk"
          echo "storage copy to${st}${param} LOCAL_SOURCE DEST \
            # Copy files from local disk to ${env}"
          echo "storage sync from${st}${param} SOURCE LOCAL_DEST \
            # Sync files from ${env} to local disk"
          echo "storage sync to${st}${param} LOCAL_SOURCE DEST \
            # Copy files from local disk to ${env}"
          for dest_env in ${taito_environments/$env/}; do
            echo "storage copy between${st}${param}:${dest_env} SOURCE DEST \
              # Copy files of bucket from ${env} to ${dest_env} "
          done
        done
      fi
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
        # Build and deploy the ${stack} artifact to ${env} environment"
      echo "artifact prepare:${stack}${suffix} \
        # Prepare ${stack} artifact for ${env} environment"
      echo "artifact release:${stack}${suffix} \
        # Release ${stack} artifact for ${env} environment"
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

#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project_path:?}"

# NOTE: Changed clean to run on host because of linux permission issues.
# We are installing libs locally anyway so perhaps it is better this way.
"${taito_cli_path}/util/execute-on-host-fg.sh" "\
  echo \"# Deleting all node_modules directories...\" && \
  find . -name \"node_modules\" -type d -prune -exec rm -rf '{}' +"

# TODO remove all flow-typed/npm directories also?

#!/bin/bash
: "${taito_project_path:?}"

echo "# Deleting all node_modules directories..."
${taito_setv:?}
find "${taito_project_path}" -name "node_modules" -type d -prune -exec \
  rm -rf '{}' +

# TODO remove all flow-typed/npm directories also?

#!/bin/bash

: "${taito_project_path:?}"

find "${taito_project_path}" -name "node_modules" -type d -prune -exec \
  rm -rf '{}' +

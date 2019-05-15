#!/bin/bash

set -x

if [ ! -d ./site ]; then
  # No site yet. Just keep container running.
  tail -f /dev/null
elif [ -f ./site/package.json ]; then
  # Gatsby development
  cd /service/site && \
  npm install && \
  npm run develop -- --host 0.0.0.0 --port 8080 --prefix-paths
fi

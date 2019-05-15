#!/bin/bash

set -x

if [ ! -d ./site ]; then
  echo No site yet.
elif [ -f ./site/package.json ]; then
  # Gatsby build
  cd site && \
  npm run build --prefix-paths && \
  cp -rf ./public/* /build
fi

# TODO configure live reload for all of these

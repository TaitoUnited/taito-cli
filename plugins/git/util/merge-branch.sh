#!/bin/bash

: "${taito_plugin_path:?}"

source=${1}
dest=${2}
options=${3}

if ! git checkout "${dest}"; then
  exit 1
fi
if ! git pull; then
  exit 1
fi
if ! git merge "${options}" "${source}"; then
  exit 1
fi
if ! git commit -v; then
  exit 1
fi
if ! git push; then
  echo "Push failed. There probably are some conflicts that need to be resolved."
  exit 1
fi
if ! git checkout -; then
  exit 1
fi

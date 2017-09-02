#!/bin/bash

source=${1}
dest=${1}

confirm=Y
echo "Rebase branch ${source} before merge (Y/n)?"
read -r confirm
if [[ ${confirm} =~ ^[Yy]$ ]]; then
  if ! git checkout "${source}"; then
    exit 1
  fi
  if ! git rebase -i "${dest}"; then
    exit 1
  fi
  if ! git checkout -; then
    exit 1
  fi
fi

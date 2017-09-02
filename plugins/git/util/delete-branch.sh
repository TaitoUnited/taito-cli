#!/bin/bash

branch=${1}

echo "Delete branch ${branch} (Y/n)?"
read -r confirm
if [[ ${confirm} =~ ^[Yy]$ ]]; then
  if ! git branch -d "${branch}"; then
    exit 1
  fi
  if ! git push origin --delete "${branch}"; then
    echo "Deleting remote branch ${branch} failed. OK if does not exists."
  fi
fi

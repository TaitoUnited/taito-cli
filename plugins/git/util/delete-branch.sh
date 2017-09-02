#!/bin/bash

branch=${1}
after=${2}
noconfirm=${3}

confirm=Y
if [[ "${noconfirm}" ]]; then
  echo "Delete branch ${branch} (Y/n)?"
  read -r confirm
fi
if [[ ${confirm} =~ ^[Yy]$ ]]; then
  if ! git checkout "${after}"; then
    exit 1
  fi
  if ! git branch -d "${branch}"; then
    exit 1
  fi
  if ! git push origin --delete "${branch}"; then
    echo "NOTE: Could not delete remote branch ${branch}."
  fi
fi

#!/bin/bash

: "${postgres_username:?}"

passwd_var="${postgres_username}_password"
passwd="${!passwd_var}"

export PGPASSWORD
if [[ -n "${passwd}" ]]; then
  # Password already set in environment variable
  PGPASSWORD="${passwd}"
else
  # Ask password from user
  echo "Password for user ${postgres_username}:"
  read -r -s PGPASSWORD
fi

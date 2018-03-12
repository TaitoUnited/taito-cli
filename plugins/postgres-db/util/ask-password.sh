#!/bin/bash
: "${database_username:?}"

passwd_var="${database_username}_password"
passwd="${!passwd_var}"

export PGPASSWORD
if [[ -n "${passwd}" ]]; then
  # Password already set in environment variable
  PGPASSWORD="${passwd}"
else
  # Ask password from user
  echo "Password for user ${database_username}:"
  read -r -s PGPASSWORD
fi
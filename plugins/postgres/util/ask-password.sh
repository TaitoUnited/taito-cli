#!/bin/bash

postgres_username=postgres
echo "Password for user ${postgres_username}:"
export PGPASSWORD
read -r -s PGPASSWORD

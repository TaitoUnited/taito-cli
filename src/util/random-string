#!/bin/bash

length=$1

# TODO better tool for this?
value=$(openssl rand -base64 40 | sed -e 's/[^a-zA-Z0-9]//g')
if [[ ${#value} -gt $length ]]; then
  value="${value: -$length}"
fi
echo "$value"

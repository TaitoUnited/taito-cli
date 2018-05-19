#!/bin/bash

# Integration test suite for zone commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
npm db-connect:dev;\
npm custom;\
"

if ! ../util/verify.sh; then
  exit 1
fi

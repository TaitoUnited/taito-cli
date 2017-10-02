#!/bin/bash

# Integration test suite for basic commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito taito-help;\
taito taito-readme;\
taito taito-trouble;\
"

if ! ../util/verify.sh; then
  exit 1
fi

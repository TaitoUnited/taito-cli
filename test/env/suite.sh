#!/bin/bash

# Integration test suite for config commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito env-config;\
taito env-create:dev;\
taito env-update:dev;\
taito env-delete:dev;\
taito env-rotate:dev;\
taito env-cert:dev;\
"

if ! ../util/verify.sh; then
  exit 1
fi

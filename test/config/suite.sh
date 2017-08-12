#!/bin/bash


# Integration test suite for config commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito config;\
taito create:dev;\
taito update:dev;\
taito delete:dev;\
taito rotate:dev;\
taito cert:dev;\
"

if ! ../util/verify.sh; then
  exit 1
fi

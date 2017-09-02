#!/bin/bash

# Integration test suite for git commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito git-merge-env;\
taito git-merge-feat;\
taito git-squash-feat;\
"

if ! ../util/verify.sh; then
  exit 1
fi

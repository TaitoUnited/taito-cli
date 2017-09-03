#!/bin/bash

# Integration test suite for git commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito git-env-merge;\
taito git-feat;\
taito git-feat-squash;\
taito git-feat-merge;\
taito git-feat-pr;\
"

if ! ../util/verify.sh; then
  exit 1
fi

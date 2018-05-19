#!/bin/bash

# Integration test suite for CI/CD commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito secrets:dev;\
taito ci-build;\
taito ci-deploy:dev;\
taito ci-canary;\
taito depl-revision:dev;\
taito depl-revert:dev;\
taito ci-wait:dev;\
taito ci-verify:dev;\
taito docs;\
taito scan;\
taito unit;\
taito test;\
taito ci-publish;\
taito ci-release-pre;\
taito ci-release-post;\
"

if ! ../util/verify.sh; then
  exit 1
fi

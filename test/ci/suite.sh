#!/bin/bash

# Integration test suite for CI/CD commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito oper-secrets:dev;\
taito ci-build;\
taito ci-deploy:dev;\
taito ci-canary;\
taito manual-revision:dev;\
taito manual-revert:dev;\
taito ci-wait:dev;\
taito ci-verify:dev;\
taito ci-docs;\
taito ci-scan;\
taito ci-test-unit;\
taito ci-test-api;\
taito ci-test-e2e;\
taito ci-publish;\
taito ci-release-pre;\
taito ci-release-post;\
"

if ! ../util/verify.sh; then
  exit 1
fi

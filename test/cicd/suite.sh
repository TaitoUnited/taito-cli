#!/bin/bash


# Integration test suite for CI/CD commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito secrets:dev;\
taito db-deploy;\
taito db-deploy:dev;\
taito db-log;\
taito db-log:dev;\
taito db-revert;\
taito db-revert:dev;\
taito deploy:dev;\
taito revision:dev;\
taito revert:dev;\
taito deployment-wait:dev;\
taito deployment-verify:dev;\
taito docs;\
taito scan;\
taito test-unit;\
taito test-api;\
taito test-e2e;\
taito publish;\
taito release-pre;\
taito release-post;\
"

if ! ../util/verify.sh; then
  exit 1
fi

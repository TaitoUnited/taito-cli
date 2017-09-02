#!/bin/bash

# Integration test suite for project commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito o-install;\
taito o-compile;\
taito o-start;\
taito o-start --clean;\
taito o-start:dev;\
taito o-run:ios;\
taito o-run:android;\
taito o-init;\
taito o-stop;\
taito o-stop:dev;\
taito o-users;\
taito o-users:dev;\
taito o-status;\
taito o-status:dev;\
taito o-log customer-app-server;\
taito o-log:dev customer-app-server;\
taito o-login customer-app-server;\
taito o-login:dev customer-app-server;\
taito o-exec customer-app-server - ls;\
taito o-exec:dev customer-app-server - ls;\
taito o-kill customer-app-server;\
taito o-kill:dev customer-app-server;\
taito o-clean;\
"

if ! ../util/verify.sh; then
  exit 1
fi

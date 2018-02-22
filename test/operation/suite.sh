#!/bin/bash

# Integration test suite for project commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito oper-install;\
taito oper-compile;\
taito oper-start;\
taito oper-start --clean;\
taito oper-start:dev;\
taito oper-run:ios;\
taito oper-run:android;\
taito oper-init;\
taito oper-stop;\
taito oper-stop:dev;\
taito oper-info;\
taito oper-info:dev;\
taito oper-status;\
taito oper-status:dev;\
taito oper-log company-app-server;\
taito oper-log:dev company-app-server;\
taito oper-shell company-app-server;\
taito oper-shell:dev company-app-server;\
taito oper-exec company-app-server - ls;\
taito oper-exec:dev company-app-server - ls;\
taito oper-kill company-app-server;\
taito oper-kill:dev company-app-server;\
taito oper-clean;\
"

if ! ../util/verify.sh; then
  exit 1
fi

#!/bin/bash

# Integration test suite for project commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito install;\
taito compile;\
taito start;\
taito start --clean;\
taito start:dev;\
taito run:ios;\
taito run:android;\
taito init;\
taito stop;\
taito stop:dev;\
taito info;\
taito info:dev;\
taito status;\
taito status:dev;\
taito log company-app-server;\
taito log:dev company-app-server;\
taito shell company-app-server;\
taito shell:dev company-app-server;\
taito exec company-app-server - ls;\
taito exec:dev company-app-server - ls;\
taito kill company-app-server;\
taito kill:dev company-app-server;\
taito clean;\
"

if ! ../util/verify.sh; then
  exit 1
fi

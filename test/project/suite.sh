#!/bin/bash


# Integration test suite for project commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
taito help;\
taito readme;\
taito trouble;\
taito install;\
taito compile;\
taito start;\
taito start --clean;\
taito start:dev;\
taito run:ios;\
taito run:android;\
taito init;\
taito open;\
taito open:dev;\
taito stop;\
taito stop:dev;\
taito users;\
taito users:dev;\
taito db-proxy:dev;\
taito db-add test.table -n 'Test table';\
taito db-open;\
taito db-open:dev;\
taito db-dump;\
taito db-dump:dev;\
taito db-import import.sql;\
taito db-import:dev import.sql;\
taito db-copy:test dev;\
taito db-copyquick:test dev;\
taito canary;\
taito status;\
taito status:dev;\
taito log customer-app-server;\
taito log:dev customer-app-server;\
taito login customer-app-server;\
taito login:dev customer-app-server;\
taito exec customer-app-server - ls;\
taito exec:dev customer-app-server - ls;\
taito kill customer-app-server;\
taito kill:dev customer-app-server;\
taito clean;\
taito upgrade;\
"

if ! ../util/verify.sh; then
  exit 1
fi

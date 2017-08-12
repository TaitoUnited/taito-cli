#!/bin/bash


# Integration test suite for zone commands
# NOTE: You should also provide some more fine grained tests for each plugin.

export tests="\
zone-install;\
zone-upgrade;\
zone-uninstall;\
devops-status;\
zone-doctor;\
zone-rotate;\
"

if ! ../util/verify.sh; then
  exit 1
fi

#!/bin/bash

# TODO implement a dynamic script

_taito ()
{
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}

  case "$cur" in
    *)
    COMPREPLY=( $( compgen -W '\
      help readme trouble auth: -- --login install compile \
      start: run: init open: stop: users: db-add db-proxy: db-open: db-dump: \
      db-import: \ db-copy: db-copyquick: canary status: logs: login: exec: kill: \
      clean config env-create: env-update: env-delete: env-rotate: env-cert: \
      db-deploy: db-log: db-revert: db-recreate: \
      build deploy: revision: revert: deployment-wait: deployment-verify: docs \
      scan test-unit test-api: test-e2e: publish release-pre: release-post: \
      cancel: secrets: contacts-development contacts-maintenance \
      open-boards open-issues open-builds open-artifacts open-logs: \
      open-errors: open-uptime open-performance open-feedback \
      fun-bofh fun-starwars zone-install zone-maintenance zone-uninstall \
      zone-status zone-doctor zone-rotate' -- $cur ) );;
  esac

  return 0
}

complete -F _taito taito

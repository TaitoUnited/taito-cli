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
    db-import: db-copy: db-copyquick: status: logs: login: exec: kill: \
    clean env-config env-create: env-update: env-delete: env-rotate: env-cert: \
    ci-db-deploy: ci-db-log: ci-db-revert: ci-db-recreate: ci-canary \
    ci-build ci-deploy: ci-revision: ci-revert: ci-wait: ci-verify: ci-docs \
    ci-scan ci-test-unit ci-test-api: ci-test-e2e: ci-publish ci-release-pre: \
    ci-release-post: ci-cancel: ci-secrets: contacts-development \
    contacts-maintenance open-boards open-issues open-builds open-artifacts \
    open-logs: open-errors: open-uptime open-performance open-feedback \
    fun-bofh fun-starwars template-create template-migrate template-upgrade \
    zone-install zone-maintenance zone-uninstall zone-status zone-doctor \
    zone-rotate' -- $cur ) );;
  esac

  return 0
}

complete -F _taito taito

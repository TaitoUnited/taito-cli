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
    -h --help --readme --trouble --auth: --upgrade -- --shell \
    install compile start: run: init stop: \
    users: status: logs: shell: exec: kill: clean \
    o-install o-compile o-start: o-run: o-init o-stop: \
    o-users: o-status: o-logs: o-shell: o-exec: o-kill: o-clean \
    workspace-clean workspace-kill \
    git-env-merge: git-feat git-feat-squash git-feat-merge git-feat-pr \
    db-add db-proxy: db-open: db-dump: db-import: \
    db-deploy: db-log: db-revert: db-recreate: db-copy: db-copyquick: \
    ci-prepare: \
    ci-build ci-push ci-deploy: ci-deployquick: ci-revision: ci-revert: \
    ci-wait: ci-verify: ci-docs ci-scan ci-test-unit ci-test-api: ci-test-e2e: \
    ci-publish ci-release-pre: ci-release-post: ci-cancel: ci-secrets: \
    env-config env-create: env-update: env-delete: env-rotate: env-cert: \
    env-alt-create: env-alt-delete: \
    contacts-development contacts-maintenance contacts-users \
    open-app: open-admin: open-boards open-bucket open-issues open-builds \
    open-artifacts open-logs: open-errors: open-uptime open-performance \
    open-feedback fun-bofh fun-starwars \
    template-create template-migrate template-upgrade \
    zone-install zone-maintenance zone-uninstall zone-status zone-doctor \
    zone-rotate' -- $cur ) );;
  esac

  return 0
}

complete -F _taito taito

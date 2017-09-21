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
    b-help b-readme b-trouble b-auth: -- --login \
    o-install o-compile o-start: o-run: o-init open-app: open-admin: o-stop: \
    o-users: o-status: o-logs: o-login: o-exec: o-kill: o-clean \
    workspace-clean workspace-kill \
    git-env-merge git-feat git-feat-squash git-feat-merge git-feat-pr \
    db-add db-proxy: db-open: db-dump: db-import: \
    db-deploy: db-log: db-revert: db-recreate: db-copy: db-copyquick: \
    ci-prepare: \
    ci-build ci-push ci-deploy: ci-deployquick: ci-revision: ci-revert: \
    ci-wait: ci-verify: ci-docs ci-scan ci-test-unit ci-test-api: ci-test-e2e: \
    ci-publish ci-release-pre: ci-release-post: ci-cancel: ci-secrets: \
    env-config env-create: env-update: env-delete: env-rotate: env-cert: \
    env-alt-create: env-alt-delete: \
    contacts-development contacts-maintenance contacts-users \
    open-boards open-issues open-builds open-artifacts \
    open-logs: open-errors: open-uptime open-performance open-feedback \
    fun-bofh fun-starwars \
    template-create template-migrate template-upgrade \
    zone-install zone-maintenance zone-uninstall zone-status zone-doctor \
    zone-rotate' -- $cur ) );;
  esac

  return 0
}

complete -F _taito taito

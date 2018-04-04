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
    info: status: logs: shell: exec: kill: clean \
    oper-install oper-env oper-build oper-start: oper-init oper-stop: \
    oper-info: oper-secrets: oper-status: oper-logs: oper-shell: oper-exec: \
    oper-kill: oper-clean oper-lock oper-analyze \
    workspace-clean workspace-kill git-env-list git-env: git-env-merge: \
    vc-feat-list vc-feat vc-feat-rebase vc-feat-squash vc-feat-merge \
    vc-feat-pr \
    db-add db-proxy: db-open: db-dump: db-import: \
    db-deploy: db-log: db-revert: db-rebase: db-recreate: db-copy: \
    db-copyquick: ci-prepare: ci-build ci-push ci-deploy: depl-cancel: \
    depl-deploy: depl-build: depl-revision: depl-revert: \
    ci-wait: ci-verify: docs scan unit test: \
    ci-publish ci-release-pre: ci-release-post: project-apply project-destroy \
    env-apply: env-destroy: env-rotate: env-cert: \
    env-alt-apply: env-alt-destroy: \
    env-alt-rotate: env-alt-cert: \
    contacts-development contacts-maintenance contacts-users \
    open-app: open-admin: open-boards open-bucket open-issues open-builds \
    open-repo open-docs open-logs: open-errors: open-uptime open-performance \
    open-feedback fun-bofh fun-starwars \
    template-create template-migrate template-upgrade \
    zone-install zone-maintenance zone-uninstall zone-status zone-doctor \
    zone-rotate \
    passwd-share passwd-list passwd-get passwd-set passwd-rotate' -- $cur ) );;
  esac

  return 0
}

complete -F _taito taito

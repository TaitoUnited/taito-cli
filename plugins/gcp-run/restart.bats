#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"
load test-helper

@test "gcp-run: restart pins the deployed digest and verifies the replacement" {
  export taito_target=server
  test restart-40
  assert_status 0
  assert_output --partial "Ready: chat-dev-server (chat-dev-server-r"
  assert_executed call-next
  calls=$(cat "${GCLOUD_CALLS}")
  [[ ${calls} == *"services update chat-dev-server --project google-project --region europe-north1 --image registry/server@sha256:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa --revision-suffix r"* ]]
  [[ ${calls} == *"--update-env-vars TAITO_RESTART_NONCE="* ]]
  assert_equal "$(grep -c '^run services describe ' "${GCLOUD_CALLS}")" 3
  assert_equal "$(grep -c '^run revisions describe ' "${GCLOUD_CALLS}")" 2
  assert_equal "$(wc -l < "${GCLOUD_CALLS}" | xargs)" 6
}

@test "gcp-run: whole-environment restart updates only configured services" {
  test restart-40
  assert_status 0
  assert_output --partial "Ready: chat-dev-server"
  assert_output --partial "Ready: chat-dev-worker"
  assert_equal "$(grep -c '^run services update ' "${GCLOUD_CALLS}")" 2
}

@test "gcp-run: immediate restarts have different nonces" {
  export taito_target=server
  test restart-40
  assert_status 0
  test restart-40
  assert_status 0
  assert_equal "$(grep '^run services update ' "${GCLOUD_CALLS}" | sed 's/.*TAITO_RESTART_NONCE=//' | sort -u | wc -l | xargs)" 2
}

@test "gcp-run: restart uses the PR environment" {
  export taito_target_env=pr-123 taito_target=server
  test restart-40
  assert_status 0
  assert_output --partial "Ready: chat-pr-123-server"
}

@test "gcp-run: all services are preflighted before mutation" {
  jq '.spec.traffic[0].latestRevision = false' "${GCLOUD_SERVICE}" > "${GCLOUD_CALLS}.chat-dev-worker"
  test restart-40
  assert_status 1
  assert_output --partial "chat-dev-worker: restart preflight failed; no services updated"
  ! grep -q '^run services update ' "${GCLOUD_CALLS}"
}

@test "gcp-run: restart rejects unsafe service configurations" {
  export taito_target=server
  for change in \
    '.spec.traffic += [{revisionName: "older", percent: 10}]' \
    '.spec.traffic[0] = {revisionName: "server-00001", percent: 100}' \
    '.spec.traffic[0].tag = "preview"' \
    '.status.traffic += [{tag: "preview", revisionName: "older", percent: 0}]' \
    '.spec.template.spec.containers += [{image: "sidecar:latest"}]' \
    '.status.conditions[0].status = "False"' \
    '.status.latestCreatedRevisionName = "pending"' \
    '.status.observedGeneration = 0' \
    '.spec.template.spec.containers[0].env = [{name: "TAITO_RESTART_NONCE", valueFrom: {secretKeyRef: {name: "secret"}}}]'; do
    jq "${change}" "${taito_plugin_path}/fixtures/service.json" > "${GCLOUD_SERVICE}"
    test restart-40
    assert_status 1
    ! grep -q '^run services update ' "${GCLOUD_CALLS}"
  done
}

@test "gcp-run: missing services and revision permissions fail before updates" {
  for failure in 'services describe' 'revisions describe'; do
    export GCLOUD_FAIL=${failure}
    test restart-40
    assert_status 1
    ! grep -q '^run services update ' "${GCLOUD_CALLS}"
  done
}

@test "gcp-run: missing or unready image digest fails before updates" {
  for change in '.status.imageDigest = "registry/server:latest"' '.status.conditions[0].status = "False"'; do
    jq "${change}" "${taito_plugin_path}/fixtures/revision.json" > "${GCLOUD_REVISION}"
    test restart-40
    assert_status 1
    ! grep -q '^run services update ' "${GCLOUD_CALLS}"
  done
}

@test "gcp-run: restart reports completed failed and unattempted services" {
  export taito_containers="server worker mailer"
  export GCLOUD_FAIL='services update chat-dev-worker'
  test restart-40
  assert_status 1
  assert_output --partial "Completed: chat-dev-server"
  assert_output --partial "Failed: chat-dev-worker (replacement chat-dev-worker-r"
  assert_output --partial "Unattempted: chat-dev-mailer"
  assert_equal "$(grep -c '^run services update ' "${GCLOUD_CALLS}")" 2
}

@test "gcp-run: restart does not report success before readiness and traffic verification" {
  export taito_target=server
  for change in \
    '.status.conditions[0].status = "False"' \
    '.status.traffic[0].revisionName = "older"' \
    '.status.latestReadyRevisionName = "older"' \
    '.spec.template.spec.containers[0].env = []'; do
    export GCLOUD_AFTER_UPDATE=${change}
    test restart-40
    assert_status 1
    assert_output --partial "Failed: chat-dev-server"
    [[ ${output} != *"Ready: chat-dev-server"* ]]
    rm "${GCLOUD_CALLS}.chat-dev-server"
  done
}

@test "gcp-run: concurrent deployment aborts before update" {
  export taito_target=server GCLOUD_CHANGED=true
  test restart-40
  assert_status 1
  assert_output --partial "changed during restart"
  ! grep -q '^run services update ' "${GCLOUD_CALLS}"
}

@test "gcp-run: restart rejects jobs unknown targets and empty selections" {
  for target in nightly serve; do
    export taito_target=${target}
    test restart-40
    assert_status 1
  done
  export taito_target="" taito_containers=""
  test restart-40
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: restart rejects instance indexes and conflicting runtimes" {
  test restart-40 0
  assert_status 1
  for plugin in docker-compose kubectl; do
    export taito_commands_only_chain="${taito_plugin_path}/restart-40 /plugins/${plugin}/restart-50"
    test restart-40
    assert_status 1
  done
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: dispatcher restarts a PR service and continues the plugin chain" {
  mkdir -p "${BATS_TEST_TMPDIR}/project" "${BATS_TEST_TMPDIR}/home"
  export TAITO_HOME="${BATS_TEST_TMPDIR}/home"
  cat > "${BATS_TEST_TMPDIR}/project/taito-config.sh" <<'CONFIG'
taito_plugins="gcp-run:-local"
taito_env=dev
taito_environments=dev
taito_project=chat
taito_containers=server
taito_zone=google-project
taito_provider_region=europe-north1
CONFIG
  cd "${BATS_TEST_TMPDIR}/project"
  run "${taito_cli_path}/src/execute-command" -q restart:server:pr-123
  assert_output --partial "Ready: chat-pr-123-server"
  assert_status 0
  assert_equal "$(grep -c '^run services update ' "${GCLOUD_CALLS}")" 1
}

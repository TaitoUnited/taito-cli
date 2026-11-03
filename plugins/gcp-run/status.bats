#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"
load test-helper

@test "gcp-run: status describes only configured services" {
  test status-40
  assert_status 0
  assert_output --partial $'chat-dev-server\tTrue\tserver-00001'
  assert_output --partial $'chat-dev-worker\tTrue\tserver-00001'
  assert_executed call-next
  assert_equal "$(cat "${GCLOUD_CALLS}")" "run services describe chat-dev-server --project google-project --region europe-north1 --format=json
run services describe chat-dev-worker --project google-project --region europe-north1 --format=json"
}

@test "gcp-run: status uses the PR environment and explicit target" {
  export taito_target_env=pr-123 taito_target=server
  test status-40
  assert_status 0
  assert_output --partial chat-pr-123-server
  assert_equal "$(wc -l < "${GCLOUD_CALLS}" | xargs)" 1
}

@test "gcp-run: status reports unready services" {
  jq '.status.conditions[0].status = "False"' "${GCLOUD_SERVICE}" > "${GCLOUD_SERVICE}.tmp"
  mv "${GCLOUD_SERVICE}.tmp" "${GCLOUD_SERVICE}"
  test status-40
  assert_status 0
  assert_output --partial $'chat-dev-server\tFalse'
}

@test "gcp-run: status fails on missing services or denied access" {
  export GCLOUD_FAIL=chat-dev-worker
  test status-40
  assert_status 1
  assert_output --partial "Could not describe Cloud Run service 'chat-dev-worker'"
}

@test "gcp-run: invalid selections fail without cloud calls" {
  export taito_target=serve
  test status-40
  assert_status 1
  export taito_target="" taito_containers=""
  test status-40
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: conflicting runtime plugins fail without cloud calls" {
  export taito_commands_only_chain="${taito_plugin_path}/status-40 /plugins/kubectl/status-50"
  test status-40
  assert_status 1
  assert_output --partial "Enable only one runtime plugin"
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: status rejects unsupported arguments" {
  test status-40 --all-namespaces
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: status propagates malformed responses" {
  echo invalid > "${GCLOUD_SERVICE}"
  test status-40
  assert_status 1
}

@test "gcp-run: dispatcher selects Cloud Run for remote and PR environments only" {
  mkdir -p "${BATS_TEST_TMPDIR}/project" "${BATS_TEST_TMPDIR}/home"
  export TAITO_HOME="${BATS_TEST_TMPDIR}/home"
  cat > "${BATS_TEST_TMPDIR}/project/taito-config.sh" <<'CONFIG'
taito_plugins="gcp-run:-local"
taito_environments="dev"
taito_env=${taito_target_env%%-*}
[[ ${taito_target_env} != pr-* ]] || taito_env=dev
taito_project=chat
taito_containers="server worker"
taito_zone=google-project
taito_provider_region=europe-north1
CONFIG
  cd "${BATS_TEST_TMPDIR}/project"
  run "${taito_cli_path}/src/execute-command" -q status:dev
  assert_output --partial chat-dev-server
  assert_status 0
  run "${taito_cli_path}/src/execute-command" -q status:pr-123
  assert_status 0
  assert_output --partial chat-pr-123-server
  : > "${GCLOUD_CALLS}"
  run "${taito_cli_path}/src/execute-command" -q status:local
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

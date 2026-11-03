#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"
load test-helper

@test "gcp-run: logs follows only the selected service" {
  export taito_target=server
  test logs-40
  assert_status 0
  assert_output --partial 'Application log line'
  assert_executed call-next
  assert_equal "$(cat "${GCLOUD_CALLS}")" "run services describe chat-dev-server --project google-project --region europe-north1 --format=json
beta run services logs tail chat-dev-server --project google-project --region europe-north1"
}

@test "gcp-run: logs uses the PR environment" {
  export taito_target=server taito_target_env=pr-123
  test logs-40
  assert_status 0
  [[ $(cat "${GCLOUD_CALLS}") == *'logs tail chat-pr-123-server '* ]]
}

@test "gcp-run: logs requires a configured container target" {
  test logs-40
  assert_status 1
  export taito_target=unknown
  test logs-40
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: logs rejects instance indexes" {
  export taito_target=server
  test logs-40 0
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: logs fails if the service cannot be described" {
  export taito_target=server GCLOUD_FAIL='services describe'
  test logs-40
  assert_status 1
  ! grep -q 'logs tail' "${GCLOUD_CALLS}"
}

@test "gcp-run: logs propagates streaming failures" {
  export taito_target=server GCLOUD_FAIL='logs tail'
  test logs-40
  assert_status 1
  [[ ${output} != *'executed: call-next'* ]]
}

@test "gcp-run: dispatcher routes targeted PR logs" {
  mkdir -p "${BATS_TEST_TMPDIR}/project" "${BATS_TEST_TMPDIR}/home"
  export TAITO_HOME="${BATS_TEST_TMPDIR}/home"
  printf '%s\n' 'taito_plugins=gcp-run:-local' 'taito_env=dev' 'taito_environments=dev' \
    > "${BATS_TEST_TMPDIR}/project/taito-config.sh"
  cd "${BATS_TEST_TMPDIR}/project"
  run "${taito_cli_path}/src/execute-command" -q logs:server:pr-123
  assert_status 0
  assert_output --partial 'Application log line'
  [[ $(cat "${GCLOUD_CALLS}") == *'logs tail chat-pr-123-server '* ]]
}

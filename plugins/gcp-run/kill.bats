#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"
load test-helper

@test "gcp-run: kill directs users to restart without cloud calls" {
  export taito_target=server
  test kill-40
  assert_status 1
  assert_output --partial 'cannot be killed through this command'
  assert_output --partial "taito restart:server:dev"
  [[ ${output} != *'executed: call-next'* ]]
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: kill guidance uses the PR environment" {
  export taito_target=server taito_target_env=pr-123
  test kill-40
  assert_status 1
  assert_output --partial 'taito restart:server:pr-123'
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: kill requires a configured target and rejects indexes" {
  test kill-40
  assert_status 1
  export taito_target=unknown
  test kill-40
  assert_status 1
  assert_output --partial "Unknown Cloud Run container 'unknown'"
  export taito_target=server
  test kill-40 0
  assert_status 1
  assert_output --partial 'without instance indexes'
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: kill rejects conflicting runtime plugins" {
  export taito_target=server
  export taito_commands_only_chain="${taito_plugin_path}/kill-40 /plugins/kubectl/kill-50"
  test kill-40
  assert_status 1
  assert_output --partial 'Enable only one runtime plugin'
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""
}

@test "gcp-run: dispatcher skips GCP authentication only for Cloud Run kill" {
  mkdir -p "${BATS_TEST_TMPDIR}/project" "${BATS_TEST_TMPDIR}/home"
  export TAITO_HOME="${BATS_TEST_TMPDIR}/home"
  export GOOGLE_APPLICATION_CREDENTIALS="${BATS_TEST_TMPDIR}/credentials.json"
  export GCLOUD_FAIL='config set'
  unset gcp_auth_already_done
  printf '%s\n' 'taito_plugins="gcp gcp-run:-local"' 'taito_env=dev' 'taito_environments=dev' \
    > "${BATS_TEST_TMPDIR}/project/taito-config.sh"
  cd "${BATS_TEST_TMPDIR}/project"
  run "${taito_cli_path}/src/execute-command" -q kill:server:pr-123
  assert_status 1
  assert_output --partial 'taito restart:server:pr-123'
  assert_equal "$(cat "${GCLOUD_CALLS}")" ""

  run "${taito_cli_path}/src/execute-command" -q status:dev
  assert_status 1
  assert_equal "$(cat "${GCLOUD_CALLS}")" 'config set disable_usage_reporting True'
}

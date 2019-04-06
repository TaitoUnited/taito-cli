#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito deployment wait'" {
  export ci_wait_test_sleep="0"
  test deployment-wait.sh

  assert_executed "call-next.sh"
  assert_executed_count 1
}

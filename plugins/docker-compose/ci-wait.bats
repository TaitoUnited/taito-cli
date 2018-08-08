#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito ci wait'" {
  export ci_wait_test_sleep="0"
  test ci-wait.sh

  assert_executed "call-next.sh"
  assert_executed_count 1
}

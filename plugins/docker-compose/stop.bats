#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito stop'" {
  test stop.sh

  assert_executed docker-compose stop
  assert_executed call-next.sh
  assert_executed_count 2
}

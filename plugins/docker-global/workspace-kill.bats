#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-global: 'taito workspace kill'" {
  test workspace-kill.sh

  assert_executed docker kill CONTAINER_ID_1 CONTAINER_ID_2
  assert_executed call-next.sh
  assert_executed_count 2
}

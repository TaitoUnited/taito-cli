#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito stop'" {
  test stop

  assert_executed docker-compose -f docker-compose.yaml stop
  assert_executed call-next
  assert_executed_count 2
}

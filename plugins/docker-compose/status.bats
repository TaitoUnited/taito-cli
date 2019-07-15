#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito status'" {
  test status

  assert_executed docker-compose -f docker-compose.yaml ps
  assert_executed call-next
  assert_executed_count 2
}

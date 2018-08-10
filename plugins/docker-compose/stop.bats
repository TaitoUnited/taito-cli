#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito stop'" {
  test stop.sh

  assert_executed docker-compose stop
  assert_executed call-next.sh
  assert_executed_count 2
}

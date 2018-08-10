#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito status'" {
  test status.sh

  assert_executed docker-compose ps
  assert_executed call-next.sh
  assert_executed_count 2
}

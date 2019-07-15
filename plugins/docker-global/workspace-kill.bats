#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-global: 'taito workspace kill'" {
  test workspace-kill

  assert_executed docker kill CONTAINER_ID_1 CONTAINER_ID_2
  assert_executed call-next
  assert_executed_count 2
}

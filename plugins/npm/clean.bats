#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper" true

@test "npm: 'taito clean'" {
  test clean

  # NOTE: removed because order is not always the same
  # assert_executed rm -rf ./node_modules ./client/node_modules
  assert_executed call-next
  assert_executed_count 2
}

@test "npm: 'taito clean:npm'" {
  export taito_target="npm"
  test clean

  # NOTE: removed because order is not always the same
  # assert_executed rm -rf ./node_modules ./client/node_modules
  assert_executed call-next
  assert_executed_count 2
}

@test "npm: 'taito clean:client'" {
  export taito_target="client"
  test clean

  assert_executed call-next
  assert_executed_count 1
}

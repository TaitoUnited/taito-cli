#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh" true

@test "npm: 'taito clean'" {
  test clean.sh

  assert_executed rm -rf ./node_modules ./client/node_modules
  assert_executed call-next.sh
  assert_executed_count 2
}

@test "npm: 'taito clean:npm'" {
  export taito_target="npm"
  test clean.sh

  assert_executed rm -rf ./node_modules ./client/node_modules
  assert_executed call-next.sh
  assert_executed_count 2
}

@test "npm: 'taito clean:client'" {
  export taito_target="client"
  test clean.sh

  assert_executed call-next.sh
  assert_executed_count 1
}

#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh" true

@test "npm: 'taito install'" {
  test install.sh

  assert_executed npm install
  assert_executed npm run install-dev
  assert_executed call-next.sh
  assert_executed_count 3
}

@test "npm: 'taito install --clean'" {
  test install.sh --clean

  assert_executed rm -rf ./node_modules ./client/node_modules
  assert_executed npm install
  assert_executed npm run install-dev
  assert_executed call-next.sh --clean
  assert_executed_count 4
}

@test "npm: 'taito install --all'" {
  test install.sh --all

  assert_executed npm install
  assert_executed npm run install-all
  assert_executed call-next.sh --all
  assert_executed_count 3
}

@test "npm: 'taito install' in 'ci' mode" {
  export taito_mode="ci"
  test install.sh

  assert_executed npm install
  assert_executed npm run install-ci
  assert_executed call-next.sh
  assert_executed_count 3
}

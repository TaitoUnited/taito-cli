#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper" true "${BATS_TEST_DIRNAME}/.."

@test "npm: 'taito command:server:dev --option parameter1 parameter2'" {
  export taito_command="command"
  export taito_target="server"
  export taito_env="dev"
  test pre --option parameter1 parameter2

  assert_executed npm run -s command:server:dev:option -- parameter1 parameter2
  assert_executed call-next --option parameter1 parameter2
  assert_executed_count 2
}

@test "npm: 'taito init'" {
  export taito_command="init"
  test pre

  assert_executed npm run -s taito-init
  assert_executed_count 1
}

@test "npm: 'taito init --clean'" {
  export taito_command="init"
  test pre --clean

  assert_executed npm run -s taito-init:clean
  assert_executed_count 1
}

@test "npm: 'taito -z init'" {
  export taito_command="init"
  export taito_skip_override="true" # -z flag skips scripts with 'taito' prefix
  test pre

  assert_executed npm run -s init
  assert_executed call-next
  assert_executed_count 2
}

@test "npm: 'taito info:prod'" {
  export taito_command="info"
  export taito_env="prod"
  test pre

  assert_executed npm run -s info:prod
  assert_executed call-next
  assert_executed_count 2
}

@test "npm: 'taito unknown'" {
  export taito_command="unknown"
  test pre

  assert_executed call-next
  assert_executed_count 1
}

@test "npm: 'taito test' with ci_exec_test false" {
  export taito_command="test"
  export taito_mode="ci"
  export ci_exec_test="false"
  export taito_env="dev"
  test pre

  assert_executed call-next
  assert_executed_count 1
}

@test "npm: 'taito test' with ci_exec_test true" {
  export taito_command="test"
  export taito_mode="ci"
  export ci_exec_test="true"
  export taito_env="dev"
  test pre

  assert_executed npm run -s test
  assert_executed call-next
  assert_executed_count 2
}

@test "npm: 'taito test' with ci_exec_test true and fail result" {
  export taito_command="test"
  export taito_mode="ci"
  export ci_exec_test="true"
  export taito_env="dev"

  # Setup temporary directory
  export TEST_TMPDIR="${BATS_TEST_DIRNAME}/../tmp"
  cd "${TEST_TMPDIR}"

  test pre fail

  assert_executed npm run -s test -- fail
  assert_executed_count 1
  [[ -f ./taitoflag_test_failed ]]
}

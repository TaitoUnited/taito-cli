#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../../unit/test-helper.sh" true "${BATS_TEST_DIRNAME}/.."

@test "npm: 'taito command:server:dev --option parameter1 parameter2'" {
  export taito_command="command"
  export taito_target="server"
  export taito_env="dev"
  result="$(${BATS_TEST_DIRNAME}/pre.sh --option parameter1 parameter2)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: npm run -s command:server:dev:option -- parameter1 parameter2 :"* ]]
  [[ "${result}" == *"executed: call-next.sh --option parameter1 parameter2 :"* ]]
}

@test "npm: 'taito init'" {
  export taito_command="init"
  result="$(${BATS_TEST_DIRNAME}/pre.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: npm run -s taito-init :"* ]]
}

@test "npm: 'taito init --clean'" {
  export taito_command="init"
  result="$(${BATS_TEST_DIRNAME}/pre.sh --clean)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: npm run -s taito-init:clean :"* ]]
}

@test "npm: 'taito -z init'" {
  export taito_command="init"
  export taito_skip_override="true" # -z flag skips scripts with 'taito' prefix
  result="$(${BATS_TEST_DIRNAME}/pre.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: npm run -s init :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito info:prod'" {
  export taito_command="info"
  export taito_env="prod"
  result="$(${BATS_TEST_DIRNAME}/pre.sh)"
  echo "${result}"
  [[ "${result}" == *"executed: npm run -s info:prod :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito unknown'" {
  export taito_command="unknown"
  result="$(${BATS_TEST_DIRNAME}/pre.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito test' with ci_exec_test false" {
  export taito_command="test"
  export taito_mode="ci"
  export ci_exec_test="false"
  export taito_env="dev"
  result="$(${BATS_TEST_DIRNAME}/pre.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito test' with ci_exec_test true" {
  export taito_command="test"
  export taito_mode="ci"
  export ci_exec_test="true"
  export taito_env="dev"
  result="$(${BATS_TEST_DIRNAME}/pre.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: npm run -s test :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito test' with ci_exec_test true and fail result" {
  export taito_command="test"
  export taito_mode="ci"
  export ci_exec_test="true"
  export taito_env="dev"

  # Setup temporary directory
  export TEST_TMPDIR="${BATS_TEST_DIRNAME}/../tmp"
  cd "${TEST_TMPDIR}"

  result="$(${BATS_TEST_DIRNAME}/pre.sh fail || :)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: npm run -s test -- fail :"* ]]
  [[ -f ./taitoflag_test_failed ]]
}

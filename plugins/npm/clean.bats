#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh" true

@test "npm: 'taito clean'" {
  result="$(${BATS_TEST_DIRNAME}/clean.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: rm -rf ./node_modules ./client/node_modules :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito clean:npm'" {
  export taito_target="npm"
  result="$(${BATS_TEST_DIRNAME}/clean.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: rm -rf ./node_modules ./client/node_modules :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito clean:client'" {
  export taito_target="client"
  result="$(${BATS_TEST_DIRNAME}/clean.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

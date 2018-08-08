#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh" true

@test "npm: 'taito install'" {
  result="$(${BATS_TEST_DIRNAME}/install.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "3" ]]
  [[ "${result}" == *"executed: npm install :"* ]]
  [[ "${result}" == *"executed: npm run install-dev :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "npm: 'taito install --clean'" {
  result="$(${BATS_TEST_DIRNAME}/install.sh --clean)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "4" ]]
  [[ "${result}" == *"executed: rm -rf ./node_modules ./client/node_modules"* ]]
  [[ "${result}" == *"executed: npm install :"* ]]
  [[ "${result}" == *"executed: npm run install-dev :"* ]]
  [[ "${result}" == *"executed: call-next.sh --clean :"* ]]
}

@test "npm: 'taito install --all'" {
  result="$(${BATS_TEST_DIRNAME}/install.sh --all)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "3" ]]
  [[ "${result}" == *"executed: npm install :"* ]]
  [[ "${result}" == *"executed: npm run install-all :"* ]]
  [[ "${result}" == *"executed: call-next.sh --all :"* ]]
}

@test "npm: 'taito install' in 'ci' mode" {
  export taito_mode="ci"
  result="$(${BATS_TEST_DIRNAME}/install.sh)"
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "3" ]]
  [[ "${result}" == *"executed: npm install :"* ]]
  [[ "${result}" == *"executed: npm run install-ci :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

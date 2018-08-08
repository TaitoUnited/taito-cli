#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito status'" {
  result=$("${BATS_TEST_DIRNAME}/status.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose ps :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

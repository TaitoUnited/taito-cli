#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito stop'" {
  result=$("${BATS_TEST_DIRNAME}/stop.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose stop :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

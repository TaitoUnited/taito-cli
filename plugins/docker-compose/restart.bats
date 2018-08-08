#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito restart'" {
  result=$("${BATS_TEST_DIRNAME}/restart.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "3" ]]
  [[ "${result}" == *"executed: docker-compose stop :"* ]]
  [[ "${result}" == *"executed: docker-compose up :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "docker-compose: 'taito restart:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/restart.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose restart acme-chat-server :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

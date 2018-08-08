#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito kill:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/kill.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker kill acme-chat-server :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

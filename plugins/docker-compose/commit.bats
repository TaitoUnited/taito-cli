#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito commit:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/commit.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "4" ]]
  [[ "${result}" == *"executed: docker ps :"* ]]
  [[ "${result}" == *"executed: docker commit acme-chat-server acme-chat-server-savetus :"* ]]
  [[ "${result}" == *"executed: docker image tag acme-chat-server-savetus acme-chat-server :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

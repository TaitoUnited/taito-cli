#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito copy from:server sourcepath destpath'" {
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/copy-from.sh" sourcepath destpath)
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker cp acme-chat-server:sourcepath destpath :"* ]]
  [[ "${result}" == *"executed: call-next.sh sourcepath destpath :"* ]]
}

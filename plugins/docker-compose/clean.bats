#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito clean'" {
  result=$("${BATS_TEST_DIRNAME}/clean.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose down --rmi local --volumes --remove-orphans :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "docker-compose: 'taito clean:server'" {
  export taito_targets="admin client server"
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/clean.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker rmi --force taito-cli_acme-chat-server :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "docker-compose: 'taito clean:npm' (do not clean docker)" {
  export taito_targets="admin client server"
  export taito_target="npm"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/clean.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "1" ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

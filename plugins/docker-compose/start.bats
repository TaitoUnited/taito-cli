#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

@test "docker-compose: 'taito start'" {
  result=$("${BATS_TEST_DIRNAME}/start.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose up :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

@test "docker-compose: 'taito start --prod'" {
  result=$("${BATS_TEST_DIRNAME}/start.sh" --prod)
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose up :"* ]]
  [[ "${result}" == *"executed: call-next.sh --prod :"* ]]
  [[ "${result}" == *"dockerfile: Dockerfile.build"* ]]
}

@test "docker-compose: 'taito start -b'" {
  result=$("${BATS_TEST_DIRNAME}/start.sh" -b)
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose up --detach :"* ]]
  [[ "${result}" == *"executed: call-next.sh -b :"* ]]
}

@test "docker-compose: 'taito start --clean'" {
  result=$("${BATS_TEST_DIRNAME}/start.sh" --clean)
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose up --force-recreate --build --remove-orphans --renew-anon-volumes :"* ]]
  [[ "${result}" == *"executed: call-next.sh --clean :"* ]]
}

@test "docker-compose: 'taito start:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/start.sh")
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose run acme-chat-server :"* ]]
  [[ "${result}" == *"executed: call-next.sh  :"* ]]
}

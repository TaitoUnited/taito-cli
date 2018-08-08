#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../unit/test-helper.sh"

# TODO run command should not work like this?
@test "docker-compose: 'taito run:server' command" {
  export taito_target="server"
  export taito_project="acme-chat"
  result=$("${BATS_TEST_DIRNAME}/run.sh" command)
  echo "${result}"
  executed_count=$(echo "${result}" | grep -c executed:)
  [[ ${executed_count} == "2" ]]
  [[ "${result}" == *"executed: docker-compose run --no-deps --entrypoint command acme-chat-server :"* ]]
  [[ "${result}" == *"executed: call-next.sh command :"* ]]
}

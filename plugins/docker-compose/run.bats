#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

# TODO run command should not work like this?
@test "docker-compose: 'taito run:server' command" {
  export taito_target="server"
  export taito_project="acme-chat"
  test run.sh command

  assert_executed docker-compose run --no-deps --entrypoint command acme-chat-server
  assert_executed call-next.sh command
  assert_executed_count 2
}

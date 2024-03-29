#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

# TODO run command should not work like this?
@test "docker-compose: 'taito run:server' command" {
  export taito_target="server"
  export taito_project="acme-chat"
  test run command

  assert_executed docker compose -f docker-compose.yaml run --no-deps --entrypoint command acme-chat-server
  assert_executed call-next command
  assert_executed_count 2
}

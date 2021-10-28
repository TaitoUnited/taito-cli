#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito clean'" {
  test clean

  assert_executed docker compose -f docker-compose.yaml down --rmi local --volumes --remove-orphans
  assert_executed call-next
  assert_executed_count 2
}

@test "docker-compose: 'taito clean:server'" {
  export taito_targets="admin client server"
  export taito_target="server"
  export taito_project="acme-chat"
  test clean

  assert_executed docker compose -f docker-compose.yaml stop acme-chat-server
  assert_executed docker compose -f docker-compose.yaml rm --force acme-chat-server
  assert_executed docker compose -f docker-compose.yaml up --force-recreate --build --no-start acme-chat-server
  assert_executed docker compose -f docker-compose.yaml start acme-chat-server
  assert_executed call-next
  assert_executed_count 5
}

@test "docker-compose: 'taito clean:npm' (do not clean docker)" {
  export taito_targets="admin client server"
  export taito_target="npm"
  export taito_project="acme-chat"
  test clean

  assert_executed call-next
  assert_executed_count 1
}

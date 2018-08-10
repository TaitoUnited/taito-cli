#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-compose: 'taito clean'" {
  test clean.sh

  assert_executed docker-compose down --rmi local --volumes --remove-orphans
  assert_executed call-next.sh
  assert_executed_count 2
}

@test "docker-compose: 'taito clean:server'" {
  export taito_targets="admin client server"
  export taito_target="server"
  export taito_project="acme-chat"
  test clean.sh

  assert_executed docker rmi --force taito-cli_acme-chat-server
  assert_executed call-next.sh
  assert_executed_count 2
}

@test "docker-compose: 'taito clean:npm' (do not clean docker)" {
  export taito_targets="admin client server"
  export taito_target="npm"
  export taito_project="acme-chat"
  test clean.sh

  assert_executed call-next.sh
  assert_executed_count 1
}

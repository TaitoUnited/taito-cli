#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-compose: 'taito start'" {
  test start

  assert_executed docker-compose -f docker-compose.yaml up
  assert_executed call-next
  assert_executed_count 2
}

@test "docker-compose: 'taito start --prod'" {
  test start --prod

  assert_executed docker-compose -f docker-compose.yaml up
  assert_executed call-next --prod
  assert_output --partial "dockerfile: Dockerfile.build"
  assert_executed_count 2
}

@test "docker-compose: 'taito start -b'" {
  test start -b

  assert_executed docker-compose -f docker-compose.yaml up --detach
  assert_executed call-next -b
  assert_executed_count 2
}

@test "docker-compose: 'taito start --clean'" {
  test start --clean

  assert_executed docker-compose -f docker-compose.yaml up --force-recreate --build --remove-orphans --renew-anon-volumes
  assert_executed call-next --clean
  assert_executed_count 2
}

@test "docker-compose: 'taito start:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test start

  assert_executed docker-compose -f docker-compose.yaml run acme-chat-server
  assert_executed call-next
  assert_executed_count 2
}

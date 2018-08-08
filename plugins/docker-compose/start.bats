#!/usr/bin/env bats

load "${BATS_TEST_DIRNAME}/../../test/util/test-helper.sh"

@test "docker-compose: 'taito start'" {
  test start.sh

  assert_executed docker-compose up
  assert_executed call-next.sh
  assert_executed_count 2
}

@test "docker-compose: 'taito start --prod'" {
  test start.sh --prod

  assert_executed docker-compose up
  assert_executed call-next.sh --prod
  assert_output --partial "dockerfile: Dockerfile.build"
  assert_executed_count 2
}

@test "docker-compose: 'taito start -b'" {
  test start.sh -b

  assert_executed docker-compose up --detach
  assert_executed call-next.sh -b
  assert_executed_count 2
}

@test "docker-compose: 'taito start --clean'" {
  test start.sh --clean

  assert_executed docker-compose up --force-recreate --build --remove-orphans --renew-anon-volumes
  assert_executed call-next.sh --clean
  assert_executed_count 2
}

@test "docker-compose: 'taito start:server'" {
  export taito_target="server"
  export taito_project="acme-chat"
  test start.sh

  assert_executed docker-compose run acme-chat-server
  assert_executed call-next.sh
  assert_executed_count 2
}

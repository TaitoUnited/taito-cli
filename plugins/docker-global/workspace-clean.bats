#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper"

@test "docker-global: 'taito workspace clean'" {
  test workspace-clean

  assert_executed docker stop CONTAINER_ID_1 CONTAINER_ID_2 CONTAINER_ID_3
  assert_executed docker volume prune
  assert_executed docker system prune -a --filter label!=fi.taitounited.taito-cli
  assert_executed docker rmi
  assert_executed call-next
  assert_executed_count 5
}

#!/usr/bin/env bats

load "${taito_cli_path}/test/util/test-helper.sh"

@test "docker-global: 'taito workspace clean'" {
  test workspace-clean.sh

  assert_executed docker stop CONTAINER_ID_1 CONTAINER_ID_2 CONTAINER_ID_3
  assert_executed docker system prune -a --filter label!=fi.taitounited.taito-cli
  assert_executed call-next.sh
  assert_executed_count 3
}

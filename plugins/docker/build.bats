#!/usr/bin/env bats

# Run directly with bats; Docker and sleeps are stubbed, so no daemon is needed.
setup() {
  source "${BATS_TEST_DIRNAME}/lib/build.bash"
  source "${BATS_TEST_DIRNAME}/lib/push.bash"
  cd "${BATS_TEST_TMPDIR}"
  export docker_log="$PWD/docker.log"
  export docker_state="$PWD/state"
  mkdir server "$docker_state"
  touch server/Dockerfile taitoflag_version "$docker_log"
  export taito_project=project
  export taito_target=server
  export taito_targets='server client'
  export taito_target_env=test
  export taito_container_registry=registry.example/project
  export taito_container_registry_provider=remote
  export taito_project_path="$PWD"
  export taito_docker_new_params=true
  export taito_ci_pull_docker_cache=true
  export taito_mode=ci
  export ci_exec_build=true
  export ci_exec_test=true
  export taito_ci_pull_always=false
  export mock_container=true
  export mock_missing='' mock_tag_failure='' mock_build_failure='' mock_push_failure=''
  export mock_manifest_failure=false
  export mock_save_failure=false
}

function taito::is_current_target_of_type () { [[ $mock_container == true ]]; }
function taito::executing_start () { :; }
function taito::skip_if_not () { :; }
function taito::call_next () { :; }
function sleep () { echo "sleep $*" >> "$docker_log"; }
function docker () {
  echo "docker $*" >> "$docker_log"
  case "$1 $2" in
    'pull '*)
      case "$mock_missing:$2" in
        all:*|cache:*:latest|runtime:*/server:revision-A|builder:*/server-builder:revision-A) return 1 ;;
      esac
      # Mutable latest deliberately contains revision B, not requested A.
      if [[ $2 == *:latest ]]; then
        echo revision-B > "$docker_state/${2//\//_}"
      else
        echo revision-A > "$docker_state/${2//\//_}"
      fi
      ;;
    'image tag')
      [[ -z $mock_tag_failure || $4 != *"$mock_tag_failure"* ]] || return 1
      cat "$docker_state/${3//\//_}" > "$docker_state/${4//\//_}"
      ;;
    'manifest inspect') [[ $mock_manifest_failure == false ]] ;;
    'buildx build')
      if [[ $mock_build_failure == builder && " $* " == *' --target builder '* ]]; then return 23; fi
      if [[ $mock_build_failure == runtime && " $* " != *' --target builder '* ]]; then return 24; fi
      ;;
    'push '*) [[ -z $mock_push_failure || $2 != *"$mock_push_failure"* ]] ;;
    'save --output')
      [[ $mock_save_failure == false ]] || return 25
      touch "$3"
      ;;
  esac
}

# Use a normal failing assertion; Bash errexit does not enforce negated commands.
refute_log() {
  if grep "$@"; then
    echo "Unexpected Docker command matched: $*" >&2
    return 1
  fi
}

build_images() {
  docker::build revision-A '' "${1:-false}" ./server ./server Dockerfile
}
push_images() {
  docker::push revision-A '' false ./server ./server Dockerfile
}
prepare_images() {
  export taito_plugin_path="$BATS_TEST_DIRNAME"
  source "${BATS_TEST_DIRNAME}/artifact-prepare-50" revision-A '' false ./server ./server Dockerfile
}

@test "docker: both builds export inline cache and use separate builder/runtime cache images" {
  run build_images
  [ "$status" -eq 0 ]
  [ "$(grep -c 'docker buildx build --load --build-arg BUILDKIT_INLINE_CACHE=1' "$docker_log")" -eq 2 ]
  grep 'docker buildx build .*--target builder .*--cache-from registry.example/project/server-builder:latest' "$docker_log"
  grep 'docker buildx build .*--cache-from registry.example/project/server-builder:latest --cache-from registry.example/project/server:latest' "$docker_log"
  refute_log -E 'docker buildx (create|use)|--push' "$docker_log"
}

@test "docker: cache disabled still builds and publishes revision-specific artifacts" {
  taito_ci_pull_docker_cache=false
  run build_images
  [ "$status" -eq 0 ]
  refute_log -E 'docker pull|--cache-from' "$docker_log"
  run push_images
  [ "$status" -eq 0 ]
  grep -Fx 'docker push registry.example/project/server:revision-A-untested' "$docker_log"
  grep -Fx 'docker push registry.example/project/server-builder:revision-A' "$docker_log"
  refute_log 'docker push .*:latest' "$docker_log"
}

@test "docker: enabled caching publishes revision builder and both optional cache images" {
  run push_images
  [ "$status" -eq 0 ]
  grep -Fx 'docker push registry.example/project/server-builder:revision-A' "$docker_log"
  grep -Fx 'docker push registry.example/project/server-builder:latest' "$docker_log"
  grep -Fx 'docker push registry.example/project/server:latest' "$docker_log"
}

@test "docker: non-container publication only pushes builder artifacts" {
  mock_container=false
  run push_images
  [ "$status" -eq 0 ]
  grep -Fx 'docker push registry.example/project/server-builder:revision-A' "$docker_log"
  grep -Fx 'docker push registry.example/project/server-builder:latest' "$docker_log"
  refute_log 'docker push registry.example/project/server:' "$docker_log"
}

@test "docker: missing optional caches permit a cold build" {
  mock_missing=cache
  run build_images
  [ "$status" -eq 0 ]
  [ "$(grep -c 'docker buildx build' "$docker_log")" -eq 2 ]
  refute_log '^sleep ' "$docker_log"
}

@test "docker: reuse selects requested revision A even when latest builder is B" {
  ci_exec_build=false
  taito_ci_pull_docker_cache=false
  echo revision-B > "$docker_state/registry.example_project_server-builder:latest"
  run build_images
  [ "$status" -eq 0 ]
  grep -Fx 'docker pull registry.example/project/server:revision-A' "$docker_log"
  grep -Fx 'docker pull registry.example/project/server-builder:revision-A' "$docker_log"
  refute_log -E 'docker (pull|image tag) [^ ]*:latest( |$)' "$docker_log"
  for alias in project-server-builder:latest project-server-builder:revision-A project-server-tester:latest; do
    [ "$(cat "$docker_state/$alias")" = revision-A ]
  done
  [ "$(cat "$docker_state/registry.example_project_server-builder:latest")" = revision-B ]
  refute_log 'docker buildx build' "$docker_log"
}

@test "docker: images-exist flag also reuses the revision-specific builder" {
  touch taitoflag_images_exist
  run build_images
  [ "$status" -eq 0 ]
  grep -Fx 'docker pull registry.example/project/server-builder:revision-A' "$docker_log"
  refute_log 'docker pull .*:latest' "$docker_log"
}

@test "docker: missing required runtime fails after 80 attempts without retagging" {
  ci_exec_build=false
  mock_missing=runtime
  run build_images
  [ "$status" -eq 1 ]
  [[ $output == *'after 80 attempts'* ]]
  [ "$(grep -c 'docker pull .*server:revision-A$' "$docker_log")" -eq 80 ]
  [ "$(grep -c '^sleep 30$' "$docker_log")" -eq 79 ]
  refute_log 'docker image tag' "$docker_log"
  refute_log 'docker buildx build' "$docker_log"
}

@test "docker: missing revision builder never falls back to latest" {
  ci_exec_build=false
  mock_missing=builder
  run build_images
  [ "$status" -eq 1 ]
  [ "$(grep -c 'docker pull .*server-builder:revision-A$' "$docker_log")" -eq 80 ]
  refute_log 'docker pull .*:latest' "$docker_log"
  refute_log 'docker image tag' "$docker_log"
}

@test "docker: any required tag failure is retried and cannot be masked by later tags" {
  ci_exec_build=false
  mock_tag_failure=server-tester
  run build_images
  [ "$status" -eq 1 ]
  [ "$(grep -c 'docker image tag .*project-server-tester:latest$' "$docker_log")" -eq 80 ]
  refute_log 'docker image tag .*project-server-builder:revision-A$' "$docker_log"
}

@test "docker: builder failure stops runtime build and preserves exit status" {
  mock_build_failure=builder
  run build_images
  [ "$status" -eq 23 ]
  [ "$(grep -c 'docker buildx build' "$docker_log")" -eq 1 ]
}

@test "docker: runtime failure preserves exit status even in conditional callers" {
  mock_build_failure=runtime
  run bash_conditional_build
  [ "$status" -eq 24 ]
}
bash_conditional_build() {
  if build_images; then return 0; else return $?; fi
}

@test "docker: required revision builder publication failure is fatal" {
  mock_push_failure=server-builder:revision-A
  run push_images
  [ "$status" -ne 0 ]
  refute_log 'docker push .*:latest' "$docker_log"
}

@test "docker: deployment-only reuse can inspect the runtime without pulling" {
  ci_exec_build=false
  ci_exec_test=false
  run build_images
  [ "$status" -eq 0 ]
  grep 'docker manifest inspect' "$docker_log"
  refute_log 'docker pull' "$docker_log"
}

@test "docker: saving reused images requires local builder and runtime despite manifest shortcut" {
  ci_exec_build=false
  ci_exec_test=false
  run build_images true
  [ "$status" -eq 0 ]
  grep -Fx 'docker pull registry.example/project/server-builder:revision-A' "$docker_log"
  grep -Fx 'docker save --output server-tester.docker project-server-tester:latest' "$docker_log"
  grep -Fx 'docker save --output server.docker registry.example/project/server:revision-A' "$docker_log"
}

@test "docker: legacy arguments still build with inline metadata and custom image path" {
  taito_docker_new_params=false
  run docker::build revision-A ./server ./server Dockerfile registry.example/custom
  [ "$status" -eq 0 ]
  [ "$(grep -c 'docker buildx build --load --build-arg BUILDKIT_INLINE_CACHE=1' "$docker_log")" -eq 2 ]
  grep -- '--tag registry.example/custom/server-builder:revision-A' "$docker_log"
}

@test "docker: separate targets import and export their own image references" {
  mkdir client
  touch client/Dockerfile
  run build_images
  [ "$status" -eq 0 ]
  taito_target=client
  run docker::build revision-A '' false ./client ./client Dockerfile
  [ "$status" -eq 0 ]
  grep 'docker buildx build .*--cache-from registry.example/project/client-builder:latest .*--tag registry.example/project/client-builder:latest' "$docker_log"
  grep 'docker buildx build .*--cache-from registry.example/project/client:latest .*--tag registry.example/project/client:latest' "$docker_log"
}

@test "docker: non-container publication flag is separate from cache switch" {
  mock_container=false
  taito_ci_pull_docker_cache=false
  taito_ci_cache_all_targets_with_docker=false
  run prepare_images
  [ "$status" -eq 0 ]
  refute_log 'docker push' "$docker_log"
  taito_ci_cache_all_targets_with_docker=true
  run prepare_images
  [ "$status" -eq 0 ]
  grep -Fx 'docker push registry.example/project/server-builder:revision-A' "$docker_log"
  refute_log 'docker push registry.example/project/server:' "$docker_log"
  refute_log 'docker push .*:latest' "$docker_log"
}

@test "docker: runtime publication failure cannot be masked by builder pushes" {
  mock_push_failure=server:revision-A-untested
  run push_images
  [ "$status" -ne 0 ]
  refute_log 'docker push .*server-builder' "$docker_log"
}

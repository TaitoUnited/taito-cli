#!/bin/bash
: "${taito_cli_path:?}"
: "${taito_project:?}"
: "${taito_project_path:?}"
: "${taito_registry:?}"
: "${taito_env:?}"

name=${1:?Name not given}
image_tag=${2:-dry-run}
image_path=${3}

path_suffix=""
if [[ "${name}" != "." ]]; then
  path_suffix="/${name}"
fi

if [[ "${image_path}" == "" ]]; then
  image_path="${taito_registry}"
fi

image="${image_path}${path_suffix}:${image_tag}"
image_builder="${image_path}${path_suffix}/builder:latest"
image_tester="${taito_project}-${name}-tester:latest"

# Read version number that semantic-release wrote on the package.json
version=$(grep "version" "${taito_project_path}/package.json" | \
  grep -o "[0-9].[0-9].[0-9]")

if [[ "${ci_stack:-}" != *"${name}"* ]]; then
  echo "Skipping build: ${name} not included in ci_stack"
else
  if [[ ! -f ./taitoflag_images_exist ]]; then
    if [[ "${taito_mode:-}" == "ci" ]] && [[ "${ci_exec_build:-}" == "false" ]]; then
      echo "- ERROR: Image does not exist and not building a new one because ci_exec_build is false"
      exit 1
    else
      echo "- Building image"
      (
        ${taito_setv:?}
        # We build the build stage container separately so that it can be used as:
        # 1) Build cache for later builds using --cache-from
        # 2) Integration and e2e test executioner
        (
          # First try with cache
          docker build \
            --target builder \
            -f "./${name}/Dockerfile.build" \
            --build-arg BUILD_VERSION="${version}" \
            --build-arg BUILD_IMAGE_TAG="${image_tag}" \
            --cache-from "${image_builder}" \
            --tag "${image_builder}" \
            --tag "${image_tester}" \
            "./${name}" || \
          # ...then try without cache
          echo "WARN! Skipping cache. Container missing from registry: ${image_builder}"
          docker build \
            --target builder \
            -f "./${name}/Dockerfile.build" \
            --build-arg BUILD_VERSION="${version}" \
            --build-arg BUILD_IMAGE_TAG="${image_tag}" \
            --tag "${image_builder}" \
            --tag "${image_tester}" \
            "./${name}"
        ) && \
        docker build \
          -f "./${name}/Dockerfile.build" \
          --cache-from "${image_builder}" \
          --build-arg BUILD_VERSION="${version}" \
          --build-arg BUILD_IMAGE_TAG="${image_tag}" \
          --tag "${image}" "./${name}"
      )
    fi
  else
    echo "- Image ${image_tag} already exists. Pulling the existing image."
    # We have pull the image so that it exists at the end
    (${taito_setv:?}; docker pull "${image}")
  fi && \

  if [[ "${taito_mode:-}" == "ci" ]]; then
    echo "Docker images after build:" && \
    docker images
  fi
fi && \

# Call next command on command chain
"${taito_cli_path}/util/call-next.sh" "${@}"

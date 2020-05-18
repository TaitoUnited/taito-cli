#!/bin/bash -e

echo "--------------------------------------------------------------------"
echo "Environment variables defined by OpenShift builder:"
echo "https://docs.openshift.com/container-platform/4.4/builds/build-strategies.html#custom-builder-image"
echo
echo "- SOURCE_REPOSITORY: $SOURCE_REPOSITORY"
echo "- SOURCE_URI: $SOURCE_URI"
echo "- SOURCE_CONTEXT_DIR: $SOURCE_CONTEXT_DIR"
echo "- SOURCE_REF: $SOURCE_REF"
echo "- ORIGIN_VERSION: $ORIGIN_VERSION"
echo "- OUTPUT_REGISTRY: $OUTPUT_REGISTRY"
echo "- OUTPUT_IMAGE: $OUTPUT_IMAGE"
echo "- PUSH_DOCKERCFG_PATH: $PUSH_DOCKERCFG_PATH"
echo
echo "Additional environment variables:"
echo
echo "- WORKDIR: $WORKDIR"
echo "--------------------------------------------------------------------"

if [[ -f "$PUSH_DOCKERCFG_PATH" ]]; then
  echo "Setting docker credentials"
  mkdir -p "$HOME/.docker"
  cp "$PUSH_DOCKERCFG_PATH" "$HOME/.docker/config.json"
else
  echo "WARNING: No docker credentials file present"
fi

if [[ -d "$WORKDIR" ]]; then
  cd "$WORKDIR"
else
  echo "Creating temporary work dir: /tmp/work"
  mkdir /tmp/work
  cd /tmp/work
  echo "Cloning git repository"
  git clone "$SOURCE_REPOSITORY" "$SOURCE_REF"
fi

echo "Running local-ci.sh with 'taito ci run:$SOURCE_REF'"
taito ci "run:$SOURCE_REF"

#!/bin/bash
echo "NOTE: ci release pre is deprecated"
"${taito_plugin_path:?}/artifact-prepare#post.sh" "${@}"

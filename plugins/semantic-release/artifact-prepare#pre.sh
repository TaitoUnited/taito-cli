#!/bin/bash
echo "NOTE: ci release pre is deprecated"
"${taito_plugin_path:?}/build-prepare#post.sh" "${@}"
